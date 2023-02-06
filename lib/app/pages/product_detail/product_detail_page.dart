import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_burguer/app/core/extensions/formatter_extension.dart';
import 'package:vakinha_burguer/app/core/ui/base_state/base_state.dart';
import 'package:vakinha_burguer/app/core/ui/helpers/size_extensions.dart';
import 'package:vakinha_burguer/app/core/ui/styles/colors_app.dart';
import 'package:vakinha_burguer/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burguer/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burguer/app/core/ui/widgets/delivery_inc_dec.dart';
import 'package:vakinha_burguer/app/dto/order_product_dto.dart';
import 'package:vakinha_burguer/app/models/products_model.dart';
import 'package:vakinha_burguer/app/pages/product_detail/product_detail_controller.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductsModel product;
  final OrderProductDto? order;

  const ProductDetailPage({super.key, required this.product, this.order});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState
    extends BaseState<ProductDetailPage, ProductDetailController> {
  void _showConfirmDelete(int amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          title: Text(
            'Remover Produto?',
            style: context.textStyles.textBold,
          ),
          icon: const Icon(Icons.info_outline_rounded, size: 42),
          iconColor: Colors.red,
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
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
                Navigator.of(context).pop(
                  OrderProductDto(
                    product: widget.product,
                    amount: amount,
                  ),
                );
              },
              icon: const Icon(Icons.delete_forever_outlined),
              label: const Text('EXCLUIR'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final amount = widget.order?.amount ?? 1;
    controller.inital(amount, widget.order != null);
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: DeliveryAppbar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: orientation == Orientation.portrait
              ? context.percentHeight(0.88)
              : context.percentHeight(1.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: context.screenWidth,
                height: context.percentHeight(.4),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.product.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.product.name,
                  style:
                      context.textStyles.textExtraBold.copyWith(fontSize: 22),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.product.description,
                      style: context.textStyles.textRegular,
                    ),
                  ),
                ),
              ),
              Divider(color: context.colors.primary),
              Row(
                children: [
                  Container(
                    width: context.percentWidth(.5),
                    height: 68,
                    padding: const EdgeInsets.all(8),
                    child: BlocBuilder<ProductDetailController, int>(
                      builder: (context, amount) {
                        return DeliveryIncDec(
                          incrementTap: () {
                            controller.increment();
                          },
                          decrementTap: () {
                            controller.decrement();
                          },
                          amount: amount,
                        );
                      },
                    ),
                  ),
                  Container(
                    width: context.percentWidth(.5),
                    height: 68,
                    padding: const EdgeInsets.all(8),
                    child: BlocBuilder<ProductDetailController, int>(
                      builder: (context, amount) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: amount == 0 ? Colors.red : null),
                          onPressed: () {
                            if (amount == 0) {
                              _showConfirmDelete(amount);
                            } else {
                              Navigator.of(context).pop(
                                OrderProductDto(
                                  product: widget.product,
                                  amount: amount,
                                ),
                              );
                            }
                          },
                          child: Visibility(
                            replacement: Text(
                              'Excluir Produto',
                              style: context.textStyles.textExtraBold,
                            ),
                            visible: amount > 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Adicionar',
                                  style: context.textStyles.textExtraBold
                                      .copyWith(fontSize: 13),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: AutoSizeText(
                                    (widget.product.price * amount)
                                        .currencyPTBR,
                                    maxFontSize: 13,
                                    minFontSize: 5,
                                    maxLines: 1,
                                    textAlign: TextAlign.end,
                                    style: context.textStyles.textExtraBold
                                        .copyWith(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
