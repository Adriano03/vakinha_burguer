import 'dart:convert';

class ProductsModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  ProductsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  // Esse método retorna um Map<String, dynamic> com as informações dos produtos;
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }

  // Construtor cria um objeto ProductModel a partir Map<String, dynamic>;
  factory ProductsModel.fromMap(Map<String, dynamic> map) {
    return ProductsModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      image: map['image'] ?? '',
    );
  }
  // Método retorna a representação do json do objeto;
  String toJson() => json.encode(toMap());
  // Construtor cria um objeto ProductModel a partir de uma string json;
  factory ProductsModel.fromJson(String source) =>
      ProductsModel.fromMap(json.decode(source));
}
