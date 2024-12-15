import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/models/venta.dart';
import 'package:puntocell_flutter/providers/venta_provider.dart';
import 'package:puntocell_flutter/util/addventa_util.dart';
import 'package:puntocell_flutter/util/optionsventa_util.dart';

class VentaScreen extends StatelessWidget {
  const VentaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VentaProvider watch = context.watch<VentaProvider>();
    final List<Venta> ventas = watch.ventas;
    ventas.sort((a, b) => b.fecha!.compareTo(a.fecha!));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Ventas'),
      ),
      body: watch.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(builder: (context, constraint) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: DataTable2(
                    showCheckboxColumn: false,
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 600,
                    columns: const [
                            DataColumn(
                                label: Center(
                                    child: Text(
                              'Producto',
                              style: TextStyle(
                                  color: Color(0xFF525B44),
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ))),
                            DataColumn(
                                label: Center(
                              child: Text(
                                'Fecha',
                                style: TextStyle(
                                    color: Color(0xFF525B44),
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            )),
                            DataColumn(
                                label: Center(
                                    child: Text(
                              'Detalles',
                              style: TextStyle(
                                color: Color(0xFF525B44),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ))),
                          ],
                    rows: ventas.map((venta) {
                            return DataRow(
                              onSelectChanged: (bool? select) {
                                OptionVenta.show(context, venta);
                              },
                              cells: [
                                DataCell(Center(
                                  child: Text(venta.nombreP == null
                                      ? 'nulo'
                                      : venta.nombreP!),
                                )),
                                DataCell(Center(
                                  child: Text(venta.fecha == null
                                      ? 'nulo'
                                      : _formatearFecha(venta.fecha!)),
                                )),
                                DataCell(Center(
                                  child: Text(venta.detalles == null
                                      ? 'nulo'
                                      : venta.detalles!),
                                )),
                              ],
                            );
                          }).toList(),
                            ),
              );
            }),
      floatingActionButton: FloatingActionButton.extended(
        label: const Row(
          children: [
            Text(
              'Registrar Venta',
              style: TextStyle(
                  color: Color(0xFF525B44), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onPressed: () {
          context.read<VentaProvider>().changedatevnt(DateTime.now());
          AddVentaUtil.show(context, 'Registrar venta');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String _formatearFecha(DateTime fecha) {
    final DateFormat formatter = DateFormat('EEEE: dd/MM/yy');
    return formatter.format(fecha);
  }
}
