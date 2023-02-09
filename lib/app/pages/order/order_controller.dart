import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_burguer/app/dto/order_dto.dart';
import 'package:vakinha_burguer/app/dto/order_product_dto.dart';
import 'package:vakinha_burguer/app/pages/order/order_state.dart';
import 'package:vakinha_burguer/app/repositories/order/order_repository.dart';

class OrderController extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderController(this._orderRepository) : super(const OrderState.initial());

  // products vindo como argumento da orderPage no método onReady();
  Future<void> load(List<OrderProductDto> products) async {
    try {
      // Emite o OrderStatus.loading);
      emit(state.copyWith(status: OrderStatus.loading));
      // Obtém os tipos de pagamentos disponiveis
      final paymentTypes = await _orderRepository.getAllPaymentsTypes();
      // Emite o OrderStatus.loaded com os dados carregados;
      emit(state.copyWith(
        orderProducts: products,
        status: OrderStatus.loaded,
        paymentTypes: paymentTypes,
      ));
    } catch (e, s) {
      log('Error ao carregar página', error: e, stackTrace: s);
      emit(state.copyWith(
        status: OrderStatus.error,
        errorMessage: 'Erro ao carregar página',
      ));
    }
  }

  void incrementProduct(int index) {
    // Cria uma copia da lista de produtos;
    final orders = [...state.orderProducts];
    final order = orders[index];
    // Incrementa a quantidade do produto selecionado;
    orders[index] = order.copyWith(amount: order.amount + 1);
    // Emite o estado OrderStatus.updateOrder atualizando o produto;
    emit(
        state.copyWith(orderProducts: orders, status: OrderStatus.updateOrder));
  }

  void decrementProduct(int index) {
    final orders = [...state.orderProducts];
    final order = orders[index]; // Seleciona o produto na posição especificada;
    final amount = order.amount; // Obtém a quantidade atual do produto;
    // Exclusão de produtos quando decrementado para um;
    if (amount == 1) {
      if (state.status != OrderStatus.confirmRemoveProduct) {
        // Emite o status OrderStatus.confirmRemoveProduct para remoção do produto;
        emit(OrderConfirmDeleteProductState(
          orderProduct: order,
          index: index,
          status: OrderStatus.confirmRemoveProduct,
          orderProducts: state.orderProducts,
          paymentTypes: state.paymentTypes,
          errorMessage: state.errorMessage,
        ));
        return;
      } else {
        orders.removeAt(index); // Remove o produto da lista de ordens;
      }
    } else {
      // Decrementa a quantidade do produto na lista;
      orders[index] = order.copyWith(amount: order.amount - 1);
    }
    if (orders.isEmpty) {
      // Se a lista estiver vazia emite o estado OrderStatus.emptyBag;
      emit(state.copyWith(status: OrderStatus.emptyBag));
      return;
    }
    // Emite o estado rderStatus.updateOrder atualizado com a lista de ordens modificada;
    emit(
        state.copyWith(orderProducts: orders, status: OrderStatus.updateOrder));
  }

  void cancelDeleteProcess() {
    // Emite o estado OrderStatus.loaded para cancelar o processo de remoção e carregar os produtos;
    emit(state.copyWith(status: OrderStatus.loaded));
  }

  emptyBag() {
    emit(state.copyWith(status: OrderStatus.emptyBag));
  }

  Future<void> saveOrder({
    required String address,
    required String document,
    required int paymentMethodId,
  }) async {
    emit(state.copyWith(status: OrderStatus.loading));
    await _orderRepository.saveOrder(
      OrderDto(
        products: state.orderProducts,
        address: address,
        document: document,
        paymentMethodId: paymentMethodId,
      ),
    );
    emit(state.copyWith(status: OrderStatus.success));
  }
}
