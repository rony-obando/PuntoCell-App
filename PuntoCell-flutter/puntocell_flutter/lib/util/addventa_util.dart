import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/models/venta.dart';
import 'package:puntocell_flutter/providers/venta_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddVentaUtil {
  static void show(BuildContext context, String texto, Venta? venta) async {
    TextEditingController nombrecontroller = TextEditingController();
    final TextEditingController detalleController = TextEditingController();
    final TextEditingController cantidadController = TextEditingController();
    cantidadController.text = '1';
    final TextEditingController precioController = TextEditingController();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          VentaProvider watch = context.watch<VentaProvider>();
          if (venta != null) {
            detalleController.text = venta.detalles ?? 'nulo';
            cantidadController.text = venta.cantidad.toString();
            precioController.text = venta.precioventa.toString();
            nombrecontroller.text = watch.allProductos
                    .firstWhere((item) => item.Id == venta.Idproducto)
                    .nombre ??
                'nulo';
            venta.fecha != null ? watch.fecha = venta.fecha! : null;
          }
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
                            TextField(
                              controller: cantidadController,
                              keyboardType: TextInputType.number,
                              onChanged: (text) {
                                context
                                    .read<VentaProvider>()
                                    .changeNombreProd(text);
                              },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Cantidad',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //SizedBox(height: 200, child:_OptionsList(onSelected: (String value){},options: watch.productos,),),
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
                                if (watch.productos.contains(seleccion)) {
                                  context
                                      .read<VentaProvider>()
                                      .findProducto(seleccion);
                                  nombrecontroller.text = seleccion;
                                  print('Seleccionado: ${watch.prd.nombre}');
                                }
                              },
                              fieldViewBuilder: (context, controller, focusNode,
                                  onFieldSubmitted) {
                                return TextField(
                                  onSubmitted: (String value) {
                                    onFieldSubmitted();
                                    nombrecontroller=controller;
                                  },
                                  focusNode: focusNode,
                                  controller: venta == null
                                      ? controller
                                      : nombrecontroller,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre del Producto',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (String value) {
                                    context
                                        .read<VentaProvider>()
                                        .changeNombreProd(value);
                                    nombrecontroller.text = value;
                                  },
                                );
                              },
                              optionsViewBuilder:
                                  (context, onSelected, options) {
                                options = watch.productos;
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4.0,
                                    child: Container(
                                      width: 300,
                                      color: const Color(0xFFF1F0E8),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: watch.productos.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final String option =
                                              options.elementAt(index);
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              final bool highlight =
                                                  AutocompleteHighlightedOption
                                                          .of(context) ==
                                                      index;
                                              if (highlight) {
                                                // Mueve automáticamente la lista para que la opción resaltada sea visible.
                                                /*SchedulerBinding.instance
                                                      .addPostFrameCallback(
                                                          (Duration timeStamp) {
                                                    Scrollable.ensureVisible(
                                                        context,
                                                        alignment: 0.5);
                                                  });*/
                                              }
                                              return ListTile(
                                                selected: highlight,
                                                title: Text(
                                                  RawAutocomplete
                                                      .defaultStringForOption(
                                                          option),
                                                  style: TextStyle(
                                                    color: highlight
                                                        ? Colors.green
                                                        : Color(0xFF525B44),
                                                    fontWeight: highlight
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                                onTap: () {
                                                  onSelected(option);
                                                  nombrecontroller.text =
                                                      option;
                                                },
                                              ); /*Container(
                                                  
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(RawAutocomplete
                                                      .defaultStringForOption(
                                                          option)),
                                                );*/
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: precioController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              onChanged: (text) {},
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Precio Venta',
                                border: OutlineInputBorder(),
                              ),
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
                                        if (watch.productos.any((producto) =>
                                            producto.toLowerCase() ==
                                            nombrecontroller.text
                                                .toLowerCase())) {
                                          await context
                                              .read<VentaProvider>()
                                              .saveVenta(
                                                  Venta(
                                                      precioventa:
                                                          double.tryParse(
                                                                  precioController
                                                                      .text) ??
                                                              0,
                                                      cantidad: int.tryParse(
                                                              cantidadController
                                                                  .text) ??
                                                          0,
                                                      Id: '',
                                                      Idproducto: watch.prd.Id,
                                                      fecha: watch.fecha,
                                                      detalles:
                                                          detalleController
                                                              .text),
                                                  context);
                                          Navigator.of(context).pop();
                                        } else {
                                          QuickAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            type: QuickAlertType.error,
                                            title: "¡Producto no encontrado!",
                                            text:
                                                "No se ha encontrado el producto con el nombre: ${nombrecontroller.text}. por favor registrarlo",
                                            confirmBtnText: 'Ok',
                                            confirmBtnColor:
                                                const Color.fromARGB(
                                                    255, 237, 94, 94),
                                            confirmBtnTextStyle:
                                                const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                            onConfirmBtnTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        }
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

