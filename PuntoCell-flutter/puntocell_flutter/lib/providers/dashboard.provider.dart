import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:puntocell_flutter/models/producto.dart';
import 'package:puntocell_flutter/models/venta.dart';
import 'package:puntocell_flutter/repository/producto_repository.dart';
import 'package:puntocell_flutter/repository/venta_repository.dart';

class DashboardProvider extends ChangeNotifier {
  VentaRepository ventaRepository;
  ProductoRepository productoRepository;
  DashboardProvider(
      {required this.productoRepository, required this.ventaRepository});
  bool isLoading = true;
  List<Venta> ventas = [];
  List<Producto> productos = [];
  List<FlSpot> datos = [];
  int disponibles = 0;
  double recordventa = 0;
  int ventasmes = 0;
  double ingresosmes = 0;

  Future<void> changeIsLoading(bool value) async{
    isLoading = value;
    notifyListeners();
  }

  Future<void> getLineChart() async {
    await changeIsLoading(true);
    datos = [];
    ventas = await ventaRepository.fetchVentas();
    productos = await productoRepository.fetchProductos();
    List<int> ventasPorMes = List<int>.filled(12, 0);
     List<double> ventastotales = List<double>.filled(12,0);
    List<int> titles = [0,10,20,30,40,50,60,70,80,90,100,110];
    
    for (var venta in ventas) {
      DateTime fecha = venta.fecha!;
      int mes = fecha.month;
      ventasPorMes[mes - 1] += venta.cantidad; 
      ventastotales[mes-1] +=venta.precioventa;
    }
    if(titles.length==ventasPorMes.length){
      for(int i=0;i<titles.length;i++){
        datos.add(FlSpot(titles[i].toDouble(), ventasPorMes[i].toDouble()));
      }
    }
    disponibles =  productos.map((a)=>a.stock).toList().reduce((a,b)=>a!+b!)!;
    recordventa = ventastotales.reduce((a,b)=>a>b?a:b);
    var ventasmesactual =ventas.where((item)=>(item.fecha!.month == DateTime.now().month && item.fecha!.year == DateTime.now().year)).toList() ;
    ventasmes = ventasmesactual.map((item)=>item.cantidad).toList().reduce((a,b)=>a+b);
    ingresosmes = ventasmesactual.map((item)=>item.precioventa).reduce((a,b)=>a+b);
    await changeIsLoading(false);
    notifyListeners();

  }
}
