
import 'package:vakinha_burguer/app/models/products_model.dart';

class OrderProductDto {
  final ProductsModel product;
  final int amount;
  OrderProductDto({
    required this.product,
    required this.amount,
  });

  double get totalPrice => amount * product.price;
}
