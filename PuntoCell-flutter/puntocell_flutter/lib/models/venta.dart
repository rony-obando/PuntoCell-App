class Venta {
  // ignore: non_constant_identifier_names
  String Id;
  // ignore: non_constant_identifier_names
  final String? Idproducto;
  final int cantidad;
  final DateTime? fecha;
  final String? detalles;
  final double precioventa;

  Venta({
    required this.Id,
    required this.Idproducto,
    required this.cantidad,
    required this.fecha,
    required this.detalles,
    required this.precioventa
  });
  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      Id: json['Id'],
      Idproducto: json['Idproducto'],
      fecha: DateTime.parse(json['fecha']),
      detalles: json['detalles'],
      cantidad: json['cantidad'],
      precioventa: double.tryParse(json['precioventa'].toString()) ?? 0,
    );
  }
}
