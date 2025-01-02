class Producto {
  // ignore: non_constant_identifier_names
  String? Id;
  String? nombre;
  String? marca;
  int? stock;
  double? precio;
  List<String>? fotos;

  Producto({
    // ignore: non_constant_identifier_names
    required this.Id,
    required this.nombre,
    required this.marca,
    required this.stock,
    required this.precio,
    required this.fotos,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      Id: json['Id'],
      nombre: json['nombre'],
      marca: json['marca'],
      stock: json['stock'],
      precio: double.tryParse(json['precio'].toString()),
      fotos: (json['fotos'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
