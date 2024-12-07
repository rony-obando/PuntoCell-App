import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/models/producto.dart';
import 'package:puntocell_flutter/providers/producto_provider.dart';

class AddProductoUtil {
  static void show(
      BuildContext context, String texto, String? Id, Producto? prd) {
    final TextEditingController nombrecontroller = TextEditingController();
    final TextEditingController marcacontroller = TextEditingController();
    final TextEditingController stockcontroller = TextEditingController();
    if (prd != null) {
      nombrecontroller.text = prd.nombre!;
      marcacontroller.text = prd.marca!;
      stockcontroller.text = prd.stock.toString();
      context.read<ProductoProvider>().changeMarca(true);
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          ProductoProvider watch = context.watch<ProductoProvider>();

          if(prd!=null){
            watch.prd.marca=prd.marca;
            watch.prd.nombre=prd.nombre;
            watch.prd.stock=prd.stock;
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
                            controller: nombrecontroller,
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {
                              watch.prd.nombre = value;
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Nueva marca',
                                style: TextStyle(
                                    color: Color(0xFF039443), fontSize: 15),
                              ),
                              Checkbox(
                                  value: watch.nuevamarca,
                                  onChanged: (value) {
                                    context
                                        .read<ProductoProvider>()
                                        .changeMarca(value);
                                  }),
                            ],
                          ),
                          Stack(
                            children: [
                              if (!watch.nuevamarca)
                                Center(
                                    child: Row(
                                  children: [
                                    const Text(
                                      'Seleccionar: ',
                                      style: TextStyle(
                                          color: Color(0xFF525B44),
                                          fontSize: 15),
                                    ),
                                    DropdownButton<String>(
                                      padding: const EdgeInsets.only(left: 10),
                                      value: watch.valorinicial,
                                      style: const TextStyle(
                                          color: Color(0xFF525B44),
                                          fontSize: 15),
                                      onChanged: (newValue) {
                                        context
                                            .read<ProductoProvider>()
                                            .changeValorInicial(newValue);
                                        watch.prd.marca = newValue;
                                      },
                                      items: watch.marcas
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                )),
                              if (watch.nuevamarca)
                                TextField(
                                  controller: marcacontroller,
                                  decoration: const InputDecoration(
                                    labelText: 'Marca',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (String value) {
                                    watch.prd.marca = value;
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: stockcontroller,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Cantidad',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {
                              watch.prd.stock = int.tryParse(value);
                            },
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
                                      if (watch.prd.nombre!.isEmpty ||
                                          (watch.prd.marca!.isEmpty &&
                                              watch.nuevamarca)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Center(
                                              child: Text(
                                                'Favor de ingresar todos los datos!',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        Navigator.of(context).pop();
                                      } else {
                                        watch.prd.Id = Id;
                                        if (await context
                                            .read<ProductoProvider>()
                                            .addProducto(watch.prd, context)) {
                                          Navigator.of(context).pop();
                                        } else {
                                          Navigator.of(context).pop();
                                        }
                                      }
                                      if (Id!.isNotEmpty) {
                                        Navigator.of(context).pop();
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
              )));
        });
  }
}
