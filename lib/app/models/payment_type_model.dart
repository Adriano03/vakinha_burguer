import 'dart:convert';

class PaymentTypeModel {
  final int id;
  final String name;
  final String acronym;
  final bool enable;

  PaymentTypeModel({
    required this.id,
    required this.name,
    required this.acronym,
    required this.enable,
  });
  // Converte o objeto para um mapa;
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'acronym': acronym,
      'enable': enable,
    };
  }
  // Cria um objeto a partir de um mapa;
  factory PaymentTypeModel.fromMap(Map<String, dynamic> map) {
    return PaymentTypeModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      acronym: map['acronym'] ?? '',
      enable: map['enable'] ?? false,
    );
  }
  // Converte o objeto para uma string JSON;
  String toJson() => json.encode(toMap());

  // Cria um objeto a partir de uma string JSON;
  factory PaymentTypeModel.fromJson(String source) =>
      PaymentTypeModel.fromMap(json.decode(source));
}
