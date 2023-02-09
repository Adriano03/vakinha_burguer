import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:vakinha_burguer/app/core/exceptions/repository_exception.dart';
import 'package:vakinha_burguer/app/core/rest_client/custom_dio.dart';
import 'package:vakinha_burguer/app/dto/order_dto.dart';
import 'package:vakinha_burguer/app/models/payment_type_model.dart';
import 'package:vakinha_burguer/app/repositories/order/order_repository.dart';

// Adicionado a rota OrderRouter;
class OrderRepositoryImpl implements OrderRepository {
  // Instância da classe CustomDio responsável por fazer requisições HTTP;
  final CustomDio dio;

  OrderRepositoryImpl({
    required this.dio,
  });
  // Método para buscar todas as formas de pagamentos;
  @override
  Future<List<PaymentTypeModel>> getAllPaymentsTypes() async {
    try {
      // Pegar requisição(get) ao endpoint;
      final result = await dio.auth().get('/payment-types');
      // Mapeia a lista de objetovs retornados para uma lista de PaymentTypeModel;
      return result.data
          .map<PaymentTypeModel>((p) => PaymentTypeModel.fromMap(p))
          .toList();
    } on DioError catch (e, s) {
      log('Erro ao buscar formas de pagamento', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar formas de pagamento');
    }
  }

  // Método para salvar pedido;
  @override
  Future<void> saveOrder(OrderDto order) async {
    try {
      // Envia dados(post) ao endpoint, com o auth() só pode está logado; 
      await dio.auth().post('/orders', data: {
        'products': order.products
            .map((e) => {
                  'id': e.product.id,
                  'amount': e.amount,
                  'total_price': e.totalPrice,
                })
            .toList(),
        'user_id': '#userAuthRef',
        'address': order.address,
        'CPF': order.document,
        'payment_method_id': order.paymentMethodId,
      });
    } on DioError catch (e, s) {
      log('Erro ao registar pedido', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao registar pedido');
    }
  }
}
