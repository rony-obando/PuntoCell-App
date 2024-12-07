class Producto {
  // ignore: non_constant_identifier_names
  String? Id;
  String? nombre;
  String? marca;
  int? stock;

  Producto({
    // ignore: non_constant_identifier_names
    required this.Id,
    required this.nombre,
    required this.marca,
    required this.stock,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      Id: json['Id'],
      nombre: json['nombre'],
      marca: json['marca'],
      stock: json['stock'],
    );
  }
}
