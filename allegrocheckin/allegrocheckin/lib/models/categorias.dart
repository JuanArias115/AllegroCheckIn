import 'dart:convert';

class Categoria {
  String id;
  String nombre;

  Categoria({
    required this.id,
    required this.nombre,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(id: json['id'], nombre: json['nombre']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }

  static List<Categoria> parseMyDataList(List<dynamic> json) {
    List<Categoria> list =
        json.map((json) => Categoria.fromJson(json)).toList();
    return list;
  }
}
