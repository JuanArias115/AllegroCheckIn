import 'dart:convert';

class Estadia {
  String id;
  String nombre;
  String domo;
  String fecha;
  String estado;
  String abono;

  Estadia({
    required this.id,
    required this.nombre,
    required this.domo,
    required this.fecha,
    required this.estado,
    required this.abono,
  });

  static Estadia fromJson(dynamic json) {
    return Estadia(
      id: json['id'],
      nombre: json['nombre'],
      domo: json['domo'],
      fecha: json['fecha'],
      estado: json['estado'],
      abono: json['abono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'domo': domo,
      'fecha': fecha,
      'estado': estado,
      'abono': abono,
    };
  }

  static List<Estadia> parseMyDataList(List<dynamic> json) {
    List<Estadia> list = json.map((json) => Estadia.fromJson(json)).toList();
    return list;
  }
}
