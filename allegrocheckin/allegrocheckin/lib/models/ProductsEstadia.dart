import 'dart:convert';

class ProductoEstadia {
  String id;
  String idEstadia;
  String item;
  String valor;

  ProductoEstadia({
    required this.id,
    required this.idEstadia,
    required this.item,
    required this.valor,
  });

  factory ProductoEstadia.fromJson(Map<String, dynamic> json) {
    return ProductoEstadia(
      id: json['id'],
      idEstadia: json['idEstadia'],
      item: json['item'],
      valor: json['valor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idEstadia': idEstadia,
      'item': item,
      'valor': valor,
    };
  }

  static List<ProductoEstadia> parseMyDataList(List<dynamic> json) {
    List<ProductoEstadia> list =
        json.map((json) => ProductoEstadia.fromJson(json)).toList();
    return list;
  }
}
