import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/models/venta.dart';
import 'package:puntocell_flutter/providers/venta_provider.dart';
import 'package:puntocell_flutter/util/addventa_util.dart';
import 'package:puntocell_flutter/util/global_keys.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class VentaScreen extends StatelessWidget {
  const VentaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VentaProvider watch = context.watch<VentaProvider>();
    final List<Venta> ventas = watch.ventas;
    ventas.sort((a, b) => b.fecha!.compareTo(a.fecha!));
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: SafeArea(child: VentaAppBar())),
      body: LayoutBuilder(builder: (context, constraint) {
        return Stack(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  'Ventas',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFF666666)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  top: 15,
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: const Color(0xFF039443),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(
                    Icons.add,
                    color: Color(0xffefefef),
                  ),
                  label: const Text(
                    'Registrar Venta',
                    style: TextStyle(
                      color: Color(0xFFEFEFEF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (!watch.isLoading) {
                      context
                          .read<VentaProvider>()
                          .changedatevnt(DateTime.now());
                      AddVentaUtil.show(context, 'Registrar venta', null);
                    }
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: watch.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: constraint.maxHeight * 0.90,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16, top: 10),
                        child: DataTable2(
                          showCheckboxColumn: false,
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 700,
                          headingRowColor:
                              WidgetStateProperty.all(const Color(0xFF9EDF9C)),
                          columns: const [
                            DataColumn(
                                label: Center(
                                    child: Text(
                              'Cantidad',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ))),
                            DataColumn(
                                label: Center(
                                    child: Text(
                              'Producto',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ))),
                            DataColumn(
                                label: Center(
                                    child: Text(
                              'Precio venta',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ))),
                            DataColumn(
                                label: Center(
                              child: Text(
                                'Fecha',
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            )),
                            DataColumn(
                                label: Center(
                                    child: Text(
                              'Detalles',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ))),
                          ],
                          dividerThickness: 0.0,
                          rows: ventas.asMap().entries.map((entry) {
                            final int index = entry.key;
                            final venta = entry.value;
                            const Color baseColor = Color(0xFFECEBDE);
                            const Color alternateColor = Color(0xFFE5E3D4);
                            var productos = watch.productosDatatable;
                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                (states) =>
                                    index.isEven ? baseColor : alternateColor,
                              ),
                              /*onSelectChanged: (bool? select) {
                                //OptionVenta.show(context, venta);
                              },*/
                              cells: [
                                DataCell(
                                    onTapDown: (details) => _mostrarMenu(
                                        context,
                                        venta,
                                        details.globalPosition,
                                        watch),
                                    Center(
                                      child: Text(
                                        venta.cantidad.toString(),
                                      ),
                                    )),
                                DataCell(
                                    onTapDown: (details) => _mostrarMenu(
                                        context,
                                        venta,
                                        details.globalPosition,
                                        watch),
                                    Center(
                                      child: Text(productos[
                                              venta.Idproducto ?? 'nulo'] ??
                                          'nulo'),
                                    )),
                                DataCell(
                                    onTapDown: (details) => _mostrarMenu(
                                        context,
                                        venta,
                                        details.globalPosition,
                                        watch),
                                    Center(
                                      child: Text(
                                        venta.precioventa.toString(),
                                      ),
                                    )),
                                DataCell(
                                    onTapDown: (details) => _mostrarMenu(
                                        context,
                                        venta,
                                        details.globalPosition,
                                        watch),
                                    Center(
                                      child: Text(
                                        venta.fecha == null
                                            ? 'nulo'
                                            : _formatearFecha(venta.fecha!),
                                      ),
                                    )),
                                DataCell(
                                    onTapDown: (details) => _mostrarMenu(
                                        context,
                                        venta,
                                        details.globalPosition,
                                        watch),
                                    Center(
                                      child: Text(
                                        venta.detalles == null
                                            ? 'nulo'
                                            : venta.detalles!,
                                      ),
                                    )),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            )
          ],
        );
      }),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final DateFormat formatter = DateFormat('EEEE: dd/MM/yy');
    return formatter.format(fecha);
  }
}

void _mostrarMenu(BuildContext context, Venta venta, Offset globalPosition,
    VentaProvider watch) {
  final tapPosition = RelativeRect.fromLTRB(
    globalPosition.dx,
    globalPosition.dy,
    globalPosition.dx,
    globalPosition.dy,
  );

  showMenu<String>(
    context: context,
    position: tapPosition,
    items: [
      const PopupMenuItem(
          value: 'actualizar',
          child: Text(
            'Actualizar',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      const PopupMenuItem(
          value: 'borrar',
          child: Text(
            'Borrar',
            style: TextStyle(
                color: Color.fromARGB(255, 237, 94, 94),
                fontWeight: FontWeight.bold),
          )),
    ],
  ).then((value) {
    if (value == 'actualizar') {
      context.read<VentaProvider>().changedatevnt(DateTime.now());
      AddVentaUtil.show(context, 'Registrar venta', venta);
    } else if (value == 'borrar') {
      QuickAlert.show(
        barrierDismissible: false,
        context: context,
        type: QuickAlertType.confirm,
        title: "¿Estás seguro?",
        text:
            "¿Quieres eliminar la venta: ${watch.productosDatatable[venta.Idproducto] ?? 'nulo'}-${DateFormat('dd/MM/yy').format(venta.fecha!)}?",
        confirmBtnText: 'Eliminar',
        confirmBtnColor: const Color.fromARGB(255, 237, 94, 94),
        confirmBtnTextStyle: const TextStyle(fontSize: 15, color: Colors.white),
        cancelBtnText: 'Cancelar',
        cancelBtnTextStyle:
            const TextStyle(fontSize: 15, color: Color(0xFF525B44)),
        onConfirmBtnTap: () async {
          if (!watch.isLoading) {
            await context.read<VentaProvider>().deleteVenta(venta, context);
            Navigator.of(context).pop();
          }
        },
      );
    }
  });
}

class VentaAppBar extends StatelessWidget {
  const VentaAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        width: constraint.maxWidth,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 4),
              spreadRadius: -1,
            ),
          ],
        ),
        child: Stack(
          children: [
            if (Platform.isAndroid)
              Builder(builder: (context) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                );
              }),
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.search,
                  color: Color(0xFFAAAAAA),
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
