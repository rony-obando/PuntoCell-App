class Venta {
  String Id;
  final String? nombreP;
  final DateTime? fecha;
  final String? detalles;

  Venta({
    required this.Id,
    required this.nombreP,
    required this.fecha,
    required this.detalles,
  });
  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      Id: json['Id'],
      nombreP: json['nombreP'],
      fecha: DateTime.parse(json['fecha']),
      detalles: json['detalles'],
    );
  }
}
