import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/models/venta.dart';
import 'package:puntocell_flutter/providers/producto_provider.dart';
import 'package:puntocell_flutter/repository/venta_repository.dart';

class VentaProvider with ChangeNotifier {
  VentaProvider({required this.ventaRepository});

  late VentaRepository ventaRepository;
  bool isLoading = true;
  List<Venta> ventas = [];
  Venta vnt = Venta(Id: '', nombreP: '', fecha: DateTime.now(), detalles: '');
  DateTime fecha = DateTime.now();
  List<String> productos = [];
  List<String> productosfiltrados = [];

  Future<void> getProductos(BuildContext context) async {
    productos = await Provider.of<ProductoProvider>(context, listen: false)
        .fetchProductos();
    notifyListeners();
  }

  void filtrarPalabras(String query) {
    final palabrasFiltradas = productos
        .where((palabra) => palabra.toLowerCase().contains(query.toLowerCase()))
        .toList();
    productosfiltrados = palabrasFiltradas;
    notifyListeners();
  }

  Future<void> fetchVentas(BuildContext context) async {
    changeisloading(true);
    getProductos(context);
    try {
      ventas = await ventaRepository.fetchVentas();
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
                'Venta del producto: ${venta.nombreP} registrada!',
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF039443),
            content: Center(
              child: Text(
                'Venta: ${venta.nombreP} ${DateFormat('dd/MM/yy').format(venta.fecha!)} Eliminada!',
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
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
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
