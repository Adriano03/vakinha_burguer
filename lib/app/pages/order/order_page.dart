import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:vakinha_burguer/app/core/extensions/formatter_extension.dart';
import 'package:vakinha_burguer/app/core/ui/base_state/base_state.dart';
import 'package:vakinha_burguer/app/core/ui/helpers/size_extensions.dart';
import 'package:vakinha_burguer/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burguer/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burguer/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_burguer/app/dto/order_product_dto.dart';
import 'package:vakinha_burguer/app/models/payment_type_model.dart';
import 'package:vakinha_burguer/app/pages/order/order_controller.dart';
import 'package:vakinha_burguer/app/pages/order/order_state.dart';
import 'package:vakinha_burguer/app/pages/order/widget/order_field.dart';
import 'package:vakinha_burguer/app/pages/order/widget/order_product.tile.dart';
import 'package:vakinha_burguer/app/pages/order/widget/payment_types_field.dart';
import 'package:validatorless/validatorless.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final formKey = GlobalKey<FormState>();
  final addressEC = TextEditingController();
  final documentEC = MaskedTextController(mask: '000.000.000-00');
  int? paymentTypeId;

  final paymentTypeValid = ValueNotifier<bool>(true);

  // Forma alternativa de pegar dados que foi passado com argumento da shoppingBag;
  @override
  void onReady() {
    final products =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;
    // Passando os argumentos para o método load() na OrderController;
    controller.load(products);
  }

  void _showConfirmProductDialog(OrderConfirmDeleteProductState? state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          title: state != null
              ? Text(
                  'Remover o Produto..\n ${state.orderProduct.product.name}?',
                  style: context.textStyles.textBold,
                )
              : const Text('Remover todos os produtos?'),
          icon: const Icon(Icons.info_outline_rounded, size: 42),
          iconColor: Colors.red,
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                controller.cancelDeleteProcess();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
              label: const Text(
                'CANCELAR',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                state != null
                    ? controller.decrementProduct(state.index)
                    : controller.emptyBag();
              },
              icon: const Icon(Icons.delete_forever_outlined),
              label: const Text('EXCLUIR'),
            ),
          ],
        );
      },
    );
  }

  _submitFinish() {
    final valid = formKey.currentState?.validate() ?? false;
    final paymentTypeSelected = paymentTypeId != null;
    paymentTypeValid.value = paymentTypeSelected;
    if (valid && paymentTypeSelected) {
      controller.saveOrder(
        address: addressEC.text,
        document: documentEC.text,
        paymentMethodId: paymentTypeId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          loading: () => showLoader(),
          error: () {
            hideLoader();
            showError(state.errorMessage ?? 'Ocorreu um erro não informado');
          },
          confirmRemoveProduct: () {
            hideLoader();
            if (state is OrderConfirmDeleteProductState) {
              _showConfirmProductDialog(state);
            }
          },
          emptyBag: () {
            showInfo('Selecione um produto para realizar seu pedido');
            Navigator.of(context).pop(<OrderProductDto>[]);
          },
          success: () {
            hideLoader();
            Navigator.of(context).popAndPushNamed(
              '/order/completed',
              result: <OrderProductDto>[],
            );
          },
        );
      },
      // Esse widget é responsável pelo botão de back no dispositivo ou a seta voltar no app;
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(controller.state.orderProducts);
          // O false não permite que seja possível voltas através dos botõs, assim forçando a usar o navigator passando os dados;
          return false;
        },
        child: Scaffold(
          appBar: DeliveryAppbar(),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Carrinho',
                          style: context.textStyles.textTitle,
                        ),
                        IconButton(
                          onPressed: () {
                            _showConfirmProductDialog(null);
                          },
                          icon: Image.asset('assets/images/trashRegular.png'),
                        ),
                      ],
                    ),
                  ),
                ),
                // BlocSelector pega apenas um item dentro da lista, e rebuilda a tela somente se o estado for alterado;
                BlocSelector<OrderController, OrderState,
                    List<OrderProductDto>>(
                  selector: (state) => state.orderProducts,
                  builder: (context, orderProducts) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: orderProducts.length,
                        (context, index) {
                          final orderProduct = orderProducts[index];
                          return Column(
                            children: [
                              OrderProductTile(
                                index: index,
                                orderProduct: orderProduct,
                              ),
                              const SizedBox(height: 6),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total do pedido',
                              style: context.textStyles.textExtraBold.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            BlocSelector<OrderController, OrderState, double>(
                              selector: (state) => state.totalOrder,
                              builder: (context, totalOrdem) {
                                return Text(
                                  totalOrdem.currencyPTBR,
                                  style:
                                      context.textStyles.textExtraBold.copyWith(
                                    fontSize: 20,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.grey),
                      OrderField(
                        title: 'Endereço de entrega',
                        controller: addressEC,
                        validator:
                            Validatorless.required('Endereço obrigatório'),
                        hintText: 'Digite o endereço',
                      ),
                      const SizedBox(height: 10),
                      OrderField(
                        title: 'CPF',
                        controller: documentEC,
                        validator: Validatorless.required('CPF obrigatório'),
                        hintText: 'Digite o CPF',
                        textInputType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      BlocSelector<OrderController, OrderState,
                          List<PaymentTypeModel>>(
                        selector: (state) => state.paymentTypes,
                        builder: (context, paymentTypes) {
                          return ValueListenableBuilder(
                            valueListenable: paymentTypeValid,
                            builder: (_, paymentTypeValidValue, child) {
                              return PaymentTypesField(
                                paymentTypes: paymentTypes,
                                valueChanged: (value) {
                                  paymentTypeId = value;
                                },
                                valid: paymentTypeValidValue,
                                valueSelected: paymentTypeId.toString(),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: DeliveryButton(
                          width: context.screenWidth,
                          height: orientation == Orientation.portrait
                              ? context.percentHeight(.065)
                              : context.percentHeight(.11),
                          label: 'FINALIZAR',
                          onPressed: _submitFinish,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
