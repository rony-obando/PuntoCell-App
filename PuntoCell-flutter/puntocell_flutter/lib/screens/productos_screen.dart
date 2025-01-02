import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/models/producto.dart';
import 'package:puntocell_flutter/providers/producto_provider.dart';
import 'package:puntocell_flutter/util/addproducto_util.dart';
import 'package:puntocell_flutter/util/global_keys.dart';
import 'package:puntocell_flutter/util/optionsproducto_util.dart';
import 'dart:io';

// ignore: must_be_immutable
class ProductoScreen extends StatelessWidget {
  ProductoScreen({super.key});

  List<Producto> productostodos = [];
  bool isLoading = true;
  List<Producto> productos = [];

  @override
  Widget build(BuildContext context) {
    ProductoProvider watch = context.watch<ProductoProvider>();
    productostodos = watch.productosAll;
    productos = watch.productos;
    isLoading = watch.isLoading;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: SafeArea(child: AppBarProducto())),
      body: LayoutBuilder(builder: (context, constraint) {
        return Stack(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  'Productos',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFF666666)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: constraint.maxHeight * 0.90,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisExtent: constraint.maxHeight / 4,
                          maxCrossAxisExtent: Platform.isAndroid
                              ? constraint.maxWidth / 2
                              : constraint.maxWidth / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        itemCount: productos.length,
                        itemBuilder: (context, index) {
                          final producto = productos[index];
                          return Card(
                              elevation: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9EDF9C),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  title: Text(
                                      producto.nombre == null
                                          ? 'nulo'
                                          : producto.nombre!,
                                      style: const TextStyle(
                                          color: Color(0XFF333333),
                                          fontWeight: FontWeight.bold)),
                                  subtitle: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Color(
                                            0XFF333333), // Color base para todo el texto
                                        fontSize: 14, // Tamaño del texto
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${producto.marca}\n\$${producto.precio}\nDisponible: ', // Texto normal
                                        ),
                                        TextSpan(
                                          text: '${producto.stock}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    OptionsProduct.show(context, producto);
                                  },
                                ),
                              ));
                        },
                      ),
                    ),
            )
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF039443),
        elevation: 20,
        label: const Row(
          children: [
            Icon(
              Icons.add,
              color: Color(0xFFEFEFEF),
            ),
            Text(
              ' Agregar Producto',
              style: TextStyle(
                  color: Color(0xFFEFEFEF), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onPressed: () {
          context.read<ProductoProvider>().addImagen('', true);
          watch.prd.nombre = '';
          watch.prd.marca = '';
          AddProductoUtil.show(context, 'Agregar producto', '', null);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class AppBarProducto extends StatelessWidget {
  const AppBarProducto({super.key});

  @override
  Widget build(BuildContext context) {
    ProductoProvider watch = context.watch<ProductoProvider>();
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
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
              Align(
                  alignment: Platform.isAndroid
                      ? Alignment.centerRight
                      : Alignment.center,
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: (Platform.isAndroid ? 20 : 0)),
                    child: SizedBox(
                        width: constraint.maxWidth * 0.80,
                        child: TextField(
                          controller: watch.searchController,
                          decoration: InputDecoration(
                            hintText: 'Escribe nombre o marca',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        )),
                  ))
            ],
          ));
    });
  }
}
