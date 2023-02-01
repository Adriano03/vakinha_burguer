import 'package:vakinha_burguer/app/models/products_model.dart';

abstract class ProductsRepository {
  Future<List<ProductsModel>> findAllProducts();
}
