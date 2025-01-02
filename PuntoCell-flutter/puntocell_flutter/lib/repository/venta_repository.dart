import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:puntocell_flutter/models/venta.dart';

class VentaRepository {
  Future<bool> saveVenta(Venta venta) async {
    String url =
        'https://uamjl4zklxnbua6hx3l4twtkca0eyxjt.lambda-url.us-east-2.on.aws/';
    if (venta.Id.isEmpty) {
      venta.Id = 'P${DateTime.now().millisecondsSinceEpoch}';
    }
    try {
      final body = jsonEncode({
          'Id': venta.Id,
          'Idproducto': venta.Idproducto,
          'fecha': venta.fecha!.toIso8601String(),
          'detalles': venta.detalles,
          'cantidad': venta.cantidad,
          'precioventa': venta.precioventa,
        });
      final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        print(response.body);
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (ex) {
      throw Exception(ex);
    }
  }
  Future<List<Venta>> fetchVentas() async {
    String url =
        'https://pbrsts47lbcpjexrzxhlx2yuy40hbzgu.lambda-url.us-east-2.on.aws/';
        List<Venta> ventas = [];
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        ventas = data.map((json) => Venta.fromJson(json)).toList();
        return ventas;
        
      }else{
        throw Exception('Error al cargar las ventas');
      }
    } catch (ex) {
      throw Exception(ex);
    }
  }
  Future<bool> deleteVenta(Venta venta) async {
    const String url =
        'https://4t2uu3pgoh.execute-api.us-east-2.amazonaws.com/Venta/Venta';
    try {
      final body = jsonEncode({
        'headers': {
          'Content-Type': 'application/json',
        },
        'body': jsonEncode({
          'Id': venta.Id,
          'Idproducto': venta.Idproducto,
          'fecha': venta.fecha!.toIso8601String(),
          'detalles': venta.detalles,
          'cantidad': venta.cantidad,
          'precioventa': venta.precioventa,
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
