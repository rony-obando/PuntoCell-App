import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/providers/dashboard.provider.dart';
import 'package:puntocell_flutter/providers/home_provider.dart';
import 'package:puntocell_flutter/providers/producto_provider.dart';
import 'package:puntocell_flutter/providers/venta_provider.dart';
import 'package:puntocell_flutter/screens/dashboard_screen.dart';
import 'package:puntocell_flutter/screens/productos_screen.dart';
import 'package:puntocell_flutter/screens/prueba_screen.dart';
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
      width: Platform.isAndroid ? maxWidth*0.70 : maxWidth / 3.5,
      color: const Color(0XFFD5ED9F),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 40,
              left: 5,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/ic_launcher.png', width: 86),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0XFFD5ED9F),
                        side: const BorderSide(
                            width: 0, color: Colors.transparent),
                        alignment: Alignment.center,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding: const EdgeInsets.only(bottom: 20, top: 20),
                        elevation: 0),
                    onPressed: () {
                      context.read<DashboardProvider>().getLineChart();
                      context
                            .read<HomeProvider>()
                            .changeBodyWidget(const DashboardScreen());
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        // ignore: deprecated_member_use
                        SvgPicture.asset(
                          'assets/icons/dashboard.svg',
                          width: 38,
                          // ignore: deprecated_member_use
                          color: const Color(0XFF555555),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                              color: Color(0XFF333333),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor: const Color(0XFFD5ED9F),
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
                            .changeBodyWidget(ProductoScreen());
                      },
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.phone_android_outlined,
                            color: Color(0XFF555555),
                            size: 35,
                            weight: 10,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text('Producto',
                              style: TextStyle(
                                  color: Color(0XFF333333),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor: const Color(0XFFD5ED9F),
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
                          Icon(
                            Icons.attach_money_rounded,
                            color: Color(0XFF555555),
                            size: 40,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text('Ventas',
                              style: TextStyle(
                                color: Color(0XFF333333),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                  ),
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0XFFD5ED9F),
                        side: const BorderSide(
                            width: 0, color: Colors.transparent),
                        alignment: Alignment.center,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding: const EdgeInsets.only(bottom: 20, top: 20),
                        elevation: 0),
                    onPressed: () {
                      context
                            .read<HomeProvider>()
                            .changeBodyWidget(const PruebaScreen());
                    },
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.settings,
                          color: Color(0XFF555555),
                          size: 35,
                          weight: 10,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                          child: Text('Configuración',
                              style: TextStyle(
                                  color: Color(0XFF333333),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
