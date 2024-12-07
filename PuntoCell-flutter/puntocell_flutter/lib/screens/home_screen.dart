import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/providers/producto_provider.dart';
import 'package:puntocell_flutter/screens/productos_screen.dart';
import 'package:puntocell_flutter/util/navigation_util.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: HomeAppBar()),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<ProductoProvider>().fetchProductos();
                  navigatioUtil.navigateToScreen(
                      context, const ProductoScreen());
                },
                style: TextButton.styleFrom(
                  side: const BorderSide(width: 5, color: Color(0xFF039443)),
                  alignment: Alignment.center,
                  fixedSize: const Size(150, 150),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                ),
                child: const Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.phone_android,
                        color: Color(0xFF039443), // Color del icono
                        size: 80,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Productos',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  side: const BorderSide(width: 5, color: Color(0xFF039443)),
                  alignment: Alignment.center,
                  fixedSize: const Size(150, 150),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                ),
                child: const Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.attach_money_rounded,
                        color: Color(0xFF039443), // Color del icono
                        size: 80,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Ventas',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  side: const BorderSide(width: 5, color: Color(0xFF039443)),
                  alignment: Alignment.center,
                  fixedSize: const Size(150, 150),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                ),
                child: const Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.bar_chart,
                        color: Color(0xFF039443), // Color del icono
                        size: 80,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'DashBoard',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logopuntocell.png",
            height: kToolbarHeight / 1.2,
          ),
          Image.asset(
            "assets/letraslogo.png",
            height: kToolbarHeight / 1.5,
            width: 200,
          ),
        ],
      ),
    );
  }
}
