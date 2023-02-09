import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakinha_burguer/app/core/extensions/formatter_extension.dart';
import 'package:vakinha_burguer/app/core/ui/helpers/size_extensions.dart';
import 'package:vakinha_burguer/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burguer/app/dto/order_product_dto.dart';
import 'package:vakinha_burguer/app/pages/home/home_controller.dart';

class ShoppingBagWidget extends StatelessWidget {
  final List<OrderProductDto> bag;

  const ShoppingBagWidget({
    super.key,
    required this.bag,
  });

  Future<void> _goOrder(BuildContext context) async {
    final navigator = Navigator.of(context);
    final controller = context.read<HomeController>();
    final sp = await SharedPreferences.getInstance();
    // Verificar se existe key;
    if (!sp.containsKey('accessToken')) {
      // Se não tiver o token -> envio para login;
      final loginResult = await navigator.pushNamed('/auth/login');
      // Verifica se usuário voltou para home pela botão voltar ou se fez login pelo entrar;
      if (loginResult == null || loginResult == false) return;
    }
    // Se tiver token -> Envio Order;   // O updateBag pega os dados que vieram do pop() da tela OrderPage no widget WillPopScope;
    final updateBag = await navigator.pushNamed('/order', arguments: bag);
    controller.updateBag(updateBag as List<OrderProductDto>);
  }

  @override
  Widget build(BuildContext context) {
    // Fold é usado para reduzir a lista a um único valor, o valor inicial é zero. O total é o valor acumulado e element é o atual list;
    // Ou seja o total fica com o valor de toda a lista acumulada;
    var totalBag = bag
        .fold<double>(0.0, (total, element) => total += element.totalPrice)
        .currencyPTBR;

    return Container(
      width: context.screenWidth,
      height: 76,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          _goOrder(context);
        },
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.shopping_cart_outlined),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Ver Sacola',
                style: context.textStyles.textExtraBold.copyWith(fontSize: 14),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                totalBag,
                style: context.textStyles.textExtraBold.copyWith(
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
