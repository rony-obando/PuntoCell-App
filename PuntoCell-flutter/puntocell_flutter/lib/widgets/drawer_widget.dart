import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/providers/home_provider.dart';
import 'package:puntocell_flutter/providers/producto_provider.dart';
import 'package:puntocell_flutter/providers/venta_provider.dart';
import 'package:puntocell_flutter/screens/productos_screen.dart';
import 'package:puntocell_flutter/screens/venta_screen.dart';

// ignore: must_be_immutable
class DrawerWidget extends StatelessWidget {
  BuildContext context;

  DrawerWidget({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    context = this.context;
    double maxWidth = MediaQuery.of(context).size.width;
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      width: Platform.isAndroid?maxWidth/2 :  maxWidth / 3.5,
      color: Colors.green,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 5,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logopuntocell.png', width: 40),
                  const Text(
                    'Punto Cell',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontFamily: 'blazedfont',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        side: const BorderSide(
                            width: 0, color: Colors.transparent),
                        alignment: Alignment.center,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding: const EdgeInsets.only(bottom: 20, top: 20),
                        elevation: 0),
                    onPressed: () {},
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.dashboard, color: Colors.white),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
                ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        side: const BorderSide(
                            width: 0, color: Colors.transparent),
                        alignment: Alignment.center,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding: const EdgeInsets.only(bottom: 20, top: 20),
                        elevation: 0),
                    onPressed: () {
                      context.read<ProductoProvider>().fetchProductos();
                      context
                          .read<HomeProvider>()
                          .changeBodyWidget(const ProductoScreen());
                    },
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.phone_android, color: Colors.white),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Inventario',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ],
                    )),
                ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        side: const BorderSide(
                            width: 0, color: Colors.transparent),
                        alignment: Alignment.center,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding: const EdgeInsets.only(bottom: 20, top: 20),
                        elevation: 0),
                    onPressed: () {
                      context.read<VentaProvider>().fetchVentas(context);
                      context
                          .read<HomeProvider>()
                          .changeBodyWidget(const VentaScreen());
                    },
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.attach_money_rounded, color: Colors.white),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Ventas', style: TextStyle(color: Colors.white)),
                      ],
                    )),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                      Text('Support', style: TextStyle(color: Colors.white70)),
                ),
                const ListTile(
                  leading: Icon(Icons.notifications, color: Colors.white),
                  title: Text('Notifications',
                      style: TextStyle(color: Colors.white)),
                ),
                const ListTile(
                  leading: Icon(Icons.settings, color: Colors.white),
                  title:
                      Text('Settings', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
