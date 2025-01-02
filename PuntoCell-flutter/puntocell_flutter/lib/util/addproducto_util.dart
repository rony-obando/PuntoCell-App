import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/models/producto.dart';
import 'package:puntocell_flutter/providers/producto_provider.dart';
import 'package:puntocell_flutter/util/imagenoptions_util.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:puntocell_flutter/repository/dropbox_repository.dart';

class AddProductoUtil {
  static void show(
      // ignore: non_constant_identifier_names
      BuildContext context,
      String texto,
      String? Id,
      Producto? prd) {
    final TextEditingController nombrecontroller = TextEditingController();
    final TextEditingController marcacontroller = TextEditingController();
    final TextEditingController stockcontroller = TextEditingController();
    final TextEditingController precioController = TextEditingController();
    if (prd != null) {
      nombrecontroller.text = prd.nombre!;
      marcacontroller.text = prd.marca!;
      stockcontroller.text = prd.stock.toString();
      context.read<ProductoProvider>().changeMarca(true);
      precioController.text = prd.precio!.toString();
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          ProductoProvider watch = context.watch<ProductoProvider>();

          if (prd != null) {
            watch.prd.marca = prd.marca;
            watch.prd.nombre = prd.nombre;
            watch.prd.stock = prd.stock;
            watch.prd.precio = prd.precio;
            watch.prd.fotos = prd.fotos;
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
                                        newValue != null
                                            ? marcacontroller.text = newValue
                                            : null;
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
                             // watch.prd.stock = int.tryParse(value);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: precioController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onChanged: (text) {
                              watch.prd.precio = double.tryParse(text);
                            },
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
                          Stack(
                            children: [
                              if (watch.imagenes.isNotEmpty)
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        height: 200.0,
                                        enableInfiniteScroll: true,
                                        enlargeCenterPage: true,
                                        autoPlay: true,
                                        onPageChanged: (index, reason) {
                                          context
                                              .read<ProductoProvider>()
                                              .changeIndexCarousel(index);
                                        }),
                                    items: watch.imagenes.map((url) {
                                      return Container(
                                          margin: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              ImagenOptionsUtil.show(
                                                  context, url);
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                url,
                                                fit: BoxFit.cover,
                                                width: 1000,
                                              ),
                                            ),
                                          ));
                                    }).toList(),
                                  ),
                                ),
                              if (watch.imagenes.isNotEmpty)
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: IconButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF039443)),
                                      onPressed: () async {
                                        DropBoxRepository dropBoxRepository =
                                            DropBoxRepository();
                                        String response =
                                            await dropBoxRepository
                                                .selectAndUploadImage(context);
                                        // ignore: use_build_context_synchronously
                                        response.isNotEmpty
                                            ? context
                                                .read<ProductoProvider>()
                                                .addImagen(response, false)
                                            : null;
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      )),
                                ),
                            ],
                          ),
                          if (watch.imagenes.isNotEmpty)
                            AnimatedSmoothIndicator(
                              activeIndex: watch.indexCarrousel,
                              count: watch.imagenes.length,
                              effect: const WormEffect(
                                activeDotColor: Colors.black,
                                dotHeight: 10,
                                dotWidth: 10,
                              ),
                            ),
                          if (watch.imagenes.isEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                onPressed: () async {
                                  DropBoxRepository dropBoxRepository =
                                      DropBoxRepository();
                                  String response = await dropBoxRepository
                                      .selectAndUploadImage(context);
                                  // ignore: use_build_context_synchronously
                                  response.isNotEmpty
                                      ? context
                                          .read<ProductoProvider>()
                                          .addImagen(response, false)
                                      : null;
                                },
                                style: TextButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    padding: const EdgeInsets.all(10),
                                    backgroundColor: const Color(0xFF039443)),
                                child: const Text(
                                  'Agregar imagen',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 20,
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
                                        backgroundColor:
                                            const Color(0xFFE5E3D4)),
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xff333333)),
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
                                        watch.prd.fotos = watch.imagenes;
                                        if (await context
                                            .read<ProductoProvider>()
                                            .addProducto(Producto(
                                                Id: Id,
                                                nombre: nombrecontroller.text,
                                                marca: marcacontroller.text,
                                                stock: int.tryParse(
                                                    stockcontroller.text),
                                                precio: double.tryParse(
                                                    precioController.text),
                                                fotos: watch.imagenes), context)) {
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
