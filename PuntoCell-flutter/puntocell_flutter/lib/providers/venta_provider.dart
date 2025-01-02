import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/models/producto.dart';
import 'package:puntocell_flutter/models/venta.dart';
import 'package:puntocell_flutter/providers/producto_provider.dart';
import 'package:puntocell_flutter/repository/venta_repository.dart';

class VentaProvider with ChangeNotifier {
  VentaProvider({required this.ventaRepository});

  late VentaRepository ventaRepository;
  bool isLoading = true;
  List<Venta> ventas = [];
  Venta vnt = Venta(
      Id: '',
      Idproducto: '',
      fecha: DateTime.now(),
      detalles: '',
      cantidad: 0,
      precioventa: 0);
  DateTime fecha = DateTime.now();
  List<Producto> allProductos = [];
  List<String> productos = [];
  List<String> productosfiltrados = [];
  var productosDatatable = <String, String>{};
  Producto prd =
      Producto(Id: '', nombre: '', marca: '', stock: 0, precio: 0, fotos: []);

  Future<void> getProductos(BuildContext context) async {
    allProductos = await Provider.of<ProductoProvider>(context, listen: false)
        .fetchProductos();
    productos = allProductos.map((item) => item.nombre ?? 'nulo').toList();
    notifyListeners();
  }

  void findProducto(String nombre) {
    prd = allProductos.firstWhere(
        (item) => item.nombre!.toLowerCase() == nombre.toLowerCase());
    notifyListeners();
  }

  void filtrarPalabras(String query) {
    final palabrasFiltradas = productos
        .where((palabra) => palabra.toLowerCase().contains(query.toLowerCase()))
        .toList();
    productosfiltrados = palabrasFiltradas;
    notifyListeners();
  }

  String nombreProd = '';

  void changeNombreProd(String? value) {
    nombreProd = value ?? '';
    filterProducts(value!);
    notifyListeners();
  }

  void filterProducts(String query) {
    final results = allProductos
        .where((product) {
          final name = product.nombre?.toLowerCase() ?? '';
          final brand = product.marca?.toLowerCase() ?? '';
          final input = query.toLowerCase();

          return name.contains(input) || brand.contains(input);
        })
        .toList()
        .map((item) => item.nombre!)
        .toList()
        .take(4)
        .toList();

    if (query.isEmpty) {
      productos = allProductos.map((item) => item.nombre!).toList();
    } else {
      productos = results;
    }
    notifyListeners();
  }

  Future<void> fetchVentas(BuildContext context) async {
    changeisloading(true);
    await getProductos(context);
    prd.nombre = productos.first;
    try {
      ventas = await ventaRepository.fetchVentas();
      for (var p in ventas) {
        if (p.Idproducto == null) {
          productosDatatable.putIfAbsent('nulo', () => 'nulo');
        } else {
          
          productosDatatable.update((p.Idproducto!), (valorExistente) => allProductos
                  .firstWhere((item) => item.Id == p.Idproducto)
                  .nombre!,
              ifAbsent: () => allProductos
                  .firstWhere((item) => item.Id == p.Idproducto)
                  .nombre!);
        }
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      throw Exception(ex);
    }
  }

  void changeisloading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void changedatevnt(DateTime value) {
    fecha = value;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('es'),
    );
    if (pickedDate != null && pickedDate != vnt.fecha!) {
      vnt.fecha != pickedDate;
      notifyListeners();
    }
  }

  Future<void> saveVenta(Venta venta, BuildContext context) async {
    changeisloading(true);
    if (venta.Id.isEmpty) {
      venta.Id = 'P${DateTime.now().millisecondsSinceEpoch}';
    }
    try {
      bool response = await ventaRepository.saveVenta(venta);
      if (response) {
        // ignore: use_build_context_synchronously
        await fetchVentas(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF039443),
            content: Center(
              child: Text(
                'Venta del producto: ${venta.Idproducto} registrada!',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      changeisloading(false);
    } catch (ex) {
      changeisloading(false);
      throw Exception(ex);
    }
  }

  Future<void> deleteVenta(Venta venta, BuildContext context) async {
    changeisloading(true);
    try {
      bool response = await ventaRepository.deleteVenta(venta);
      if (response) {
        venta.Idproducto == null
            ? productosDatatable.remove('nulo')
            : productosDatatable.remove(allProductos
                    .firstWhere((item) => item.Id == venta.Idproducto!)
                    .nombre ??
                'nulo');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF039443),
            content: Center(
              child: Text(
                'Venta: ${venta.Id} ${DateFormat('dd/MM/yy').format(venta.fecha!)} Eliminada!',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text(
                'Ocurrió un error al eliminar el registro de la venta',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            duration: Duration(seconds: 3),
          ),
        );
        print('Error al borrar el producto:');
      }
      await fetchVentas(context);
      notifyListeners();
    } catch (ex) {
      throw Exception(ex);
    }
  }
}
