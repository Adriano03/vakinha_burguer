import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailController extends Cubit<int> {
  late final bool _hasOrder;

  ProductDetailController() : super(1);

  void increment() => emit(state + 1);

  void inital(int amount, bool hasOrder) {
    _hasOrder = hasOrder;
    emit(amount);
  }

  void decrement() {
    if (state > (_hasOrder ? 0 : 1)) {
      emit(state - 1);
    }
  }
}