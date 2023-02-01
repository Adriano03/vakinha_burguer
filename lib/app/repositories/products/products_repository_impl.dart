import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:vakinha_burguer/app/core/exceptions/repository_exception.dart';
import 'package:vakinha_burguer/app/core/rest_client/custom_dio.dart';
import 'package:vakinha_burguer/app/models/products_model.dart';

import './products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final CustomDio dio;

  ProductsRepositoryImpl({
    required this.dio,
  });

  @override
  Future<List<ProductsModel>> findAllProducts() async {
    try {
      final result = await dio.unAuth().get('/products');
      return result.data
          .map<ProductsModel>((p) => ProductsModel.fromMap(p))
          .toList();
    } on DioError catch (e, s) {
      log('Erro ao buscar Produtos', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar Produtos');
    }
  }
}
