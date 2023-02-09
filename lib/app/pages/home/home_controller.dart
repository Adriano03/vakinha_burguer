import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:vakinha_burguer/app/dto/order_product_dto.dart';

import 'package:vakinha_burguer/app/pages/home/home_state.dart';
import 'package:vakinha_burguer/app/repositories/products/products_repository.dart';

class HomeController extends Cubit<HomeState> {
  final ProductsRepository _productsRepository;

  HomeController(
    this._productsRepository,
  ) : super(const HomeState.initial());

  Future<void> loadProducts() async {
    // Emite o estado de loading antes de buscar os produtos;
    emit(state.copyWith(status: HomeStateStatus.loading));
    try {
      // Emite o estado de loaded já com os produtos carregados;
      final products = await _productsRepository.findAllProducts();
      emit(state.copyWith(status: HomeStateStatus.loaded, products: products));
    } catch (e, s) {
      log('Erro ao buscar produtos', error: e, stackTrace: s);
      emit(
        state.copyWith(
            status: HomeStateStatus.error,
            errorMessage: 'Erro ao buscar produtos'),
      );
    }
  }

  void addOrUpdateBag(OrderProductDto orderProduct) {
    // É colocado o spread [...] exclui os dados da lista e cria outros para poder notificar o bloc;
    final shoppingBag = [...state.shoppingBag];
    // O indexWhere procura na lista shoppingBag que contém o mesmo produto orderProduct;
    final orderIndex = shoppingBag
        .indexWhere((orderP) => orderP.product == orderProduct.product);

    if (orderIndex > -1) {
      if (orderProduct.amount == 0) {
        shoppingBag.removeAt(orderIndex);
      } else {
        shoppingBag[orderIndex] = orderProduct;
      }
    } else {
      shoppingBag.add(orderProduct);
    }

    emit(state.copyWith(shoppingBag: shoppingBag));
  }

  // Atualizar sacola de produtos quando vem para a home;
  void updateBag(List<OrderProductDto> updateBag) {
    emit(state.copyWith(shoppingBag: updateBag));
  }
}
