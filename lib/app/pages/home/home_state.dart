import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

import 'package:vakinha_burguer/app/models/products_model.dart';

part 'home_state.g.dart';

@match
enum HomeStateStatus {
  inital,
  loading,
  loaded,
  error,
}

class HomeState extends Equatable {
  final HomeStateStatus status;
  final List<ProductsModel> products;
  final String? errorMessage;

  const HomeState({
    required this.status,
    required this.products,
    this.errorMessage,
  });

  const HomeState.initial()
      : status = HomeStateStatus.inital,
        products = const [],
        errorMessage = null;

  @override
  List<Object?> get props => [status, products, errorMessage];

  HomeState copyWith({
    HomeStateStatus? status,
    List<ProductsModel>? products,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
