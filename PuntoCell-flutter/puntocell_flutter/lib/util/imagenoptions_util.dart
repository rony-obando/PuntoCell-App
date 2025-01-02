import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/providers/producto_provider.dart';

class ImagenOptionsUtil {
  static void show(BuildContext context, String url) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.network(url, width: 200),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 237, 94, 94)),
                        onPressed: () {
                          context.read<ProductoProvider>().deleteImagen(url);
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
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
                      child: const SizedBox(
                        width: 100,
                        child: Row(
                        children: [
                          Icon(Icons.arrow_back_rounded,color: Color(0xff333333),),
                          Text(
                            'Cancelar',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xff333333)),
                          ),
                        ],
                      ),
                      )),
                ),
              ),
            ],
          ));
        });
  }
}
