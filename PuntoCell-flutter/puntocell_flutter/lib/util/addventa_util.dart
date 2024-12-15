import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/models/venta.dart';
import 'package:puntocell_flutter/providers/venta_provider.dart';

class AddVentaUtil {
  static void show(BuildContext context, String texto) async {
    final TextEditingController nombrecontroller = TextEditingController();
    final TextEditingController detalleController = TextEditingController();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          VentaProvider watch = context.watch<VentaProvider>();
          return AlertDialog(
              scrollable: true,
              title: SingleChildScrollView(
                  child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: watch.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            Text(
                              texto,
                              style: const TextStyle(
                                  color: Color(0xFF039443),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                return watch.productos.where((palabra) =>
                                    palabra.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase()));
                              },
                              onSelected: (String seleccion) {
                                print('Seleccionado: $seleccion');
                              },
                              fieldViewBuilder: (context, controller, focusNode,
                                  onFieldSubmitted) {
                                return TextField(
                                  focusNode: focusNode,
                                  controller: controller,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre del Producto',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (String value) {
                                    nombrecontroller.text=value;
                                  },
                                );
                              },
                              optionsViewBuilder:
                                  (context, onSelected, options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width/1.5,
                                      color: const Color(0xFFF1F0E8),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final option =
                                              options.elementAt(index);
                                          return ListTile(
                                            title: Text(option, style: const TextStyle(color: Color(0xFF525B44), fontWeight: FontWeight.bold),),
                                            onTap: () {
                                              onSelected(option);
                                              nombrecontroller.text=option;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),                            
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Fecha:',
                                  style: TextStyle(
                                      color: Color(0xFF525B44),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final DateTime? pickedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: watch.fecha,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      locale: const Locale('es'),
                                    );
                                    if (pickedDate != null &&
                                        pickedDate != watch.vnt.fecha!) {
                                      // ignore: use_build_context_synchronously
                                      context
                                          .read<VentaProvider>()
                                          .changedatevnt(pickedDate);
                                    }
                                  },
                                  child: Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(watch.fecha),
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xFF039443),
                                        fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: detalleController,
                              decoration: const InputDecoration(
                                labelText: 'Detalles',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value) {},
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(10),
                                          backgroundColor: const Color.fromARGB(
                                              255, 237, 94, 94)),
                                      child: const Text(
                                        'Cancelar',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await context
                                            .read<VentaProvider>()
                                            .saveVenta(
                                                Venta(
                                                    Id: '',
                                                    nombreP:
                                                        nombrecontroller.text,
                                                    fecha: watch.fecha,
                                                    detalles:
                                                        detalleController.text),
                                                context);
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(10),
                                          backgroundColor:
                                              const Color(0xFF039443)),
                                      child: const Text(
                                        'Aceptar',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                ),
              ));
        });
  }
}
