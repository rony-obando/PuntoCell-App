import 'package:flutter/material.dart';
import 'package:puntocell_flutter/models/producto.dart';
import 'package:puntocell_flutter/repository/producto_repository.dart';
import 'package:uuid/uuid.dart';

class ProductoProvider with ChangeNotifier {
  ProductoProvider({required this.productoRepository}) {
    searchController.addListener(() {
      filterProducts(searchController.text);
    });
  }
  late ProductoRepository productoRepository;


  final TextEditingController searchController = TextEditingController();

  void filterProducts(String query) {
    final results = productosAll.where((product) {
      final name = product.nombre?.toLowerCase() ?? '';
      final brand = product.marca?.toLowerCase() ?? '';
      final input = query.toLowerCase();

      return name.contains(input) || brand.contains(input);
    }).toList();

    if (query.isEmpty) {
      productos = productosAll;
    } else {
      productos = results;
    }
    notifyListeners();
  }


  List<Producto> productosAll = [];
  List<Producto> productos = [];
  Producto prd = Producto(Id: '', nombre: '', marca: '', stock: 0, precio: 0, fotos: []);
  bool isLoading = true;
  List<String> marcas = [];
  bool nuevamarca = false;
  String valorinicial = '';
  var uuid = const Uuid();
  bool deleted = false;
  int indexCarrousel = 0;
  List<String> imagenes = [];

  bool changedeleted() {
    deleted = !deleted;
    return !deleted;
  }

  void changeIndexCarousel(int i){
    indexCarrousel = i;
    notifyListeners();
  }

  void addImagen(String value,bool reset){
    imagenes.add(value);
    reset?imagenes.clear():null;
    notifyListeners();
  }
  void deleteImagen(String value){
    imagenes.remove(value);
    notifyListeners();
  }

  Future<List<Producto>> fetchProductos() async {
    changeisloading(true);
    try {
      final response = await productoRepository.fetchProductos();
      
      if (response.isNotEmpty) {
        productos = response;
        productosAll = productos;
        isLoading = false;
        marcas = productosAll
            .map((item) => item.marca == null ? 'nulo' : item.marca!)
            .toList();
        marcas = marcas.toSet().toList();
        valorinicial = marcas.first;
        notifyListeners();
        return productosAll;
      } else {
        throw Exception('Error al cargar los productos');
        
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return [];
    }
  }

  void changeMarca(bool? value) {
    nuevamarca = value ?? nuevamarca;
    notifyListeners();
  }

  void changeValorInicial(String? value) {
    valorinicial = value ?? valorinicial;
    notifyListeners();
  }

  Future<void> changeProdcuto(Producto prd) async{
    prd=prd;
    notifyListeners();
  }

  void changeisloading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<bool> addProducto(Producto producto, BuildContext context) async {
    changeisloading(true);
    if (!nuevamarca) {
      producto.marca = valorinicial;
    }
    try {
      producto.fotos=imagenes;
      bool response = await productoRepository.addProducto(producto);
      if (response) {
        await fetchProductos();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF039443),
            content: Center(
              child: Text(
                'Producto: ${prd.nombre} ${(prd.Id!.isEmpty ? 'Guardado!' : 'Actualizado!')}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        notifyListeners();

        return true;
      } else {
        notifyListeners();
        return false;
      }
    } catch (ex) {
      throw Exception(ex);
    }
  }

  Future<void> deleteProducto(Producto producto) async {
    changeisloading(true);
    try {
      bool response = await productoRepository.deleteProducto(producto);
      if (response) {
        print('Se ha borrado el producto: ${producto.Id}');
      } else {
        print('Error al borrar el producto: ${producto.Id}');
      }
      fetchProductos();
      notifyListeners();
    } catch (ex) {
      throw Exception(ex);
    }
  }
}
