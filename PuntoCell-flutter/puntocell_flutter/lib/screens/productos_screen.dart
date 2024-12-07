import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/models/producto.dart';
import 'package:puntocell_flutter/providers/producto_provider.dart';
import 'package:puntocell_flutter/util/addproducto_util.dart';
import 'package:puntocell_flutter/util/optionsproducto_util.dart';

class ProductoScreen extends StatefulWidget {
  const ProductoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductoScreenState createState() => _ProductoScreenState();
}

class _ProductoScreenState extends State<ProductoScreen> {
  List<Producto> productostodos = [];
  bool isLoading = true;
  List<Producto> productos = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductoProvider watch = context.watch<ProductoProvider>();
    productostodos = watch.productosAll;
    productos = watch.productos;
    isLoading = watch.isLoading;
    return Scaffold(
      appBar: AppBar(
          title: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: kToolbarHeight / 1.5,
                child: TextField(
                  controller: watch.searchController,
                  decoration: InputDecoration(
                    hintText: 'Escribe nombre o marca',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ))),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: 250,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 50),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                                producto.nombre == null
                                    ? 'nulo'
                                    : producto.nombre!,
                                style: const TextStyle(
                                    color: Color(0xFF525B44),
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                '${producto.marca} - Disponible: ${producto.stock}',
                                style: const TextStyle(
                                  color: Color(0xFF525B44),
                                )),
                            onTap: () {
                              OptionsProduct.show(context, producto);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Row(
          children: [
            Icon(
              Icons.add,
              color: Color(0xFF525B44),
            ),
            Text(
              ' Agregar Producto',
              style: TextStyle(
                  color: Color(0xFF525B44), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onPressed: () {
          watch.prd.nombre = '';
          watch.prd.marca = '';
          AddProductoUtil.show(context, 'Agregar producto', '', null);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
