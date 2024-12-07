import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:puntocell_flutter/models/producto.dart';
import 'package:uuid/uuid.dart';

class ProductoProvider with ChangeNotifier {
  ProductoProvider() {
    searchController.addListener(() {
      filterProducts(searchController.text);
    });
  }

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
  Producto prd = Producto(Id: '', nombre: '', marca: '', stock: 0);
  bool isLoading = true;
  List<String> marcas = [];
  bool nuevamarca = false;
  String valorinicial = '';
  var uuid = const Uuid();
  bool deleted = false;

  bool changedeleted() {
    deleted = !deleted;
    return !deleted;
  }

  Future<void> fetchProductos() async {
    const String url =
        'https://ygftut36b7.execute-api.us-east-2.amazonaws.com/Producto/Producto';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> bodyData = jsonDecode(data['body']);

        productos = bodyData.map((item) => Producto.fromJson(item)).toList();
        productosAll = productos;
        isLoading = false;
        marcas = productosAll
            .map((item) => item.marca == null ? 'nulo' : item.marca!)
            .toList();
        marcas = marcas.toSet().toList();
        valorinicial = marcas.first;
        notifyListeners();
      } else {
        throw Exception('Error al cargar los productos');
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
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

  void changeisloading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<bool> addProducto(Producto producto, BuildContext context) async {
    changeisloading(true);
    if (!nuevamarca) {
      producto.marca = valorinicial;
    }
    if (producto.Id!.isEmpty) {
      producto.Id = 'P${DateTime.now().millisecondsSinceEpoch}';
    }
    const String url =
        'https://ygftut36b7.execute-api.us-east-2.amazonaws.com/Producto/Producto';
    try {
      final body = jsonEncode({
        'resource': '/Producto/Producto',
        'path': '/Producto/Producto',
        'httpMethod': 'POST',
        'headers': {
          'Content-Type': 'application/json',
        },
        'body': jsonEncode({
          'Id': producto.Id,
          'nombre': producto.nombre,
          'marca': producto.marca,
          'stock': producto.stock,
        }),
        'isBase64Encoded': false
      });
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        print(response.body);
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
        print('Error al crear el producto: ${response.body}');
        notifyListeners();

        return false;
      }
    } catch (ex) {
      throw Exception(ex);
    }
  }

  Future<void> deleteProducto(Producto producto) async {
    changeisloading(true);
    const String url =
        'https://ygftut36b7.execute-api.us-east-2.amazonaws.com/Producto/Producto';
    try {
      final body = jsonEncode({
        'headers': {
          'Content-Type': 'application/json',
        },
        'body': jsonEncode({
          'Id': producto.Id,
          'nombre': producto.nombre,
          'marca': producto.marca,
          'stock': producto.stock,
        }),
        'isBase64Encoded': false
      });
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        print(response.body);
      } else {
        print('Error al borrar el producto: ${response.body}');
      }
      fetchProductos();
      notifyListeners();
    } catch (ex) {
      throw Exception(ex);
    }
  }
}
