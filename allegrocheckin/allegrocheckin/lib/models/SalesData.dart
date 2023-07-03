import 'dart:convert';

class SalesData {
  String categoria;
  String valor;

  SalesData({
    required this.categoria,
    required this.valor,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(categoria: json['categoria'], valor: json['valor']);
  }

  Map<String, dynamic> toJson() {
    return {
      'categoria': categoria,
      'valor': valor,
    };
  }

  static List<SalesData> parseMyDataList(List<dynamic> json) {
    List<SalesData> list =
        json.map((json) => SalesData.fromJson(json)).toList();
    return list;
  }
}
