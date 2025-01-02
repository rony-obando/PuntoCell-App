import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puntocell_flutter/models/venta.dart';
import 'package:puntocell_flutter/repository/venta_repository.dart';

class PruebaScreen extends StatelessWidget {
  const PruebaScreen({super.key});

  Future<void> saveVentasMasivas(String filePath) async {
  // Cargar el archivo JSON
  String jsonString = await rootBundle.loadString(filePath);
  List<dynamic> ventasList = jsonDecode(jsonString);

  // Enviar registros en lotes de 10
  int batchSize = 10;
  for (int i = 0; i < ventasList.length; i += batchSize) {
    List<dynamic> batch = ventasList.sublist(
      i,
      i + batchSize > ventasList.length ? ventasList.length : i + batchSize,
    );

    // Enviar cada venta en el lote
    for (var ventaJson in batch) {
      Venta venta = Venta(
        Id: ventaJson['Id'],
        Idproducto: ventaJson['Idproducto'],
        detalles: ventaJson['detalles'],
        cantidad: ventaJson['cantidad'],
        fecha: DateTime.parse(ventaJson['fecha']),
        precioventa: ventaJson['precioventa']!,
      );
      VentaRepository ventaRepository = VentaRepository();
      bool success = await (ventaRepository.saveVenta(venta));
      if (success) {
        print("Venta ${venta.Id} guardada con éxito");
      } else {
        print("Error al guardar la venta ${venta.Id}");
      }
    }

    // Esperar 1 segundo entre lotes
    await Future.delayed(Duration(seconds: 1));
  }
}


  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body:  Center(
          child: ElevatedButton(onPressed: (){
            saveVentasMasivas('assets/sales_data.json');
          }, child: const Text('Enviar'))
        ),
      ),
    );
  }
}