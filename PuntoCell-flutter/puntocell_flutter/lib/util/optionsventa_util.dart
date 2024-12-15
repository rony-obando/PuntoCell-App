import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/models/venta.dart';
import 'package:puntocell_flutter/providers/venta_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class OptionVenta {
  static void show(BuildContext context, Venta vnt) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          VentaProvider watch = context.watch<VentaProvider>();
          return AlertDialog(
            title: watch.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Opciones para: ',
                                  style: TextStyle(
                                    color: Color(0xFF039443),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: vnt.nombreP == null
                                      ? 'nulo'
                                      : vnt.nombreP!,
                                  style: const TextStyle(
                                    color: Color(0xFF525B44),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          QuickAlert.show(
                            barrierDismissible: false,
                            context: context,
                            type: QuickAlertType.confirm,
                            title: "¿Estás seguro?",
                            text:
                                "¿Quieres eliminar la venta: ${vnt.nombreP == null ? 'nulo' : vnt.nombreP!} ${DateFormat('dd/MM/yy').format(vnt.fecha!)}?",
                            confirmBtnText: 'Eliminar',
                            confirmBtnColor:
                                const Color.fromARGB(255, 237, 94, 94),
                            confirmBtnTextStyle: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            cancelBtnText: 'Cancelar',
                            cancelBtnTextStyle: const TextStyle(
                                fontSize: 15, color: Color(0xFF525B44)),
                            onConfirmBtnTap: () async {
                              if (!watch.isLoading) {
                                await context
                                    .read<VentaProvider>()
                                    .deleteVenta(vnt, context);

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            backgroundColor:
                                const Color.fromARGB(255, 237, 94, 94)),
                        child: const Text(
                          'Borrar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                        ),
                        child: const Text(
                          'Actualizar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF525B44)),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }

  void showConfirmationDialog(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Confirmación',
      text: '¿Estás seguro de que quieres continuar?',
      confirmBtnText: 'Sí',
      cancelBtnText: 'No',
      onConfirmBtnTap: () {
        // Acción cuando se confirma
        Navigator.of(context).pop();
      },
      onCancelBtnTap: () {
        // Acción cuando se cancela
        Navigator.of(context).pop();
      },
    );
  }
}
