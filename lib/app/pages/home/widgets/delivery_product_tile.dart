import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vakinha_burguer/app/core/extensions/formatter_extension.dart';
import 'package:vakinha_burguer/app/core/ui/styles/colors_app.dart';
import 'package:vakinha_burguer/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burguer/app/dto/order_product_dto.dart';

import 'package:vakinha_burguer/app/models/products_model.dart';
import 'package:vakinha_burguer/app/pages/home/home_controller.dart';

class DeliveryProductTile extends StatelessWidget {
  final ProductsModel product;
  final OrderProductDto? orderProduct;

  const DeliveryProductTile({
    super.key,
    required this.product,
    required this.orderProduct,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final controller = context.read<HomeController>();
        // Passando produto como argumento para productDetailRouter onde foi passado como arg para ProductDetailPage;
        // Na tela de ProductDetail foi feito um pop(product e amount) e colocado na variável orderProductResult;
        final orderProductResult =
            await Navigator.of(context).pushNamed('/productDetail', arguments: {
          'product': product,
          'order': orderProduct,
        }); 

        if (orderProductResult != null) {
          // O flutter gera um aviso quando passa o context.read<HomeController>() depois do await, então foi colocado,
          // na váriavel controller antes do await para não ter nenhum warning;
          controller.addOrUpdateBag(orderProductResult as OrderProductDto);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          product.name,
                          style: context.textStyles.textExtraBold
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          product.description,
                          style: context.textStyles.textRegular
                              .copyWith(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          product.price.currencyPTBR,
                          style: context.textStyles.textMedium.copyWith(
                            fontSize: 12,
                            color: context.colors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: product.image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Divider(color: context.colors.primary),
          ],
        ),
      ),
    );
  }
}
