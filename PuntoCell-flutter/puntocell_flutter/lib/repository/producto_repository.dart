import 'dart:convert';

import 'package:puntocell_flutter/models/producto.dart';
import 'package:http/http.dart' as http;

class ProductoRepository {
  Future<bool> addProducto(Producto producto) async {
    if (producto.Id!.isEmpty) {
      producto.Id = 'P${DateTime.now().millisecondsSinceEpoch}';
    }
    const String url =
        'https://syyg2jtgo6zux2d3qa6giilwwa0riwyc.lambda-url.us-east-2.on.aws/';
    try {
      final body = jsonEncode({
        'Id': producto.Id,
        'nombre': producto.nombre,
        'marca': producto.marca,
        'stock': producto.stock,
        'fotos': producto.fotos,
        'precio': producto.precio,
      });
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception(ex);
    }
  }

  Future<List<Producto>> fetchProductos() async {
    const String url =
        'https://idjc2m5tecgciw4spyp3zkgo540emkdf.lambda-url.us-east-2.on.aws/';
    List<Producto> prds = [];
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        prds = data.map((json) => Producto.fromJson(json)).toList();
        return prds;
      } else {
        throw Exception('Error al cargar los productos');
      }
    } catch (e) {
      throw Exception('Error al cargar los productos: $e');
    }
  }

  Future<bool> deleteProducto(Producto producto) async {
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
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      throw Exception(ex);
    }
  }
}
