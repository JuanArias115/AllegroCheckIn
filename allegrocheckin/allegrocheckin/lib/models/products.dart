import 'dart:convert';

class Producto {
  String id;
  String item;
  String valor;
  String categoria;

  Producto({
    required this.id,
    required this.item,
    required this.valor,
    required this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      item: json['item'],
      valor: json['valor'],
      categoria: json['categoria'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item': item,
      'valor': valor,
      'categoria': categoria,
    };
  }

  static List<Producto> parseMyDataList(List<dynamic> json) {
    List<Producto> list = json.map((json) => Producto.fromJson(json)).toList();
    return list;
  }
}
