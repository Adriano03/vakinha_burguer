import 'package:flutter/material.dart';
import 'package:vakinha_burguer/app/core/global/global_context.dart';
import 'package:vakinha_burguer/app/core/provider/application_binding.dart';
import 'package:vakinha_burguer/app/core/ui/theme/theme_config.dart';
import 'package:vakinha_burguer/app/pages/auth/login/login_router.dart';
import 'package:vakinha_burguer/app/pages/auth/register/register_router.dart';
import 'package:vakinha_burguer/app/pages/home/home_router.dart';
import 'package:vakinha_burguer/app/pages/order/order_router.dart';
import 'package:vakinha_burguer/app/pages/order/widget/order_completed_page.dart';
import 'package:vakinha_burguer/app/pages/product_detail/product_detail_router.dart';
import 'package:vakinha_burguer/app/pages/splash/splash_page.dart';

class DeliveryApp extends StatelessWidget {
  final _navKey = GlobalKey<NavigatorState>();

  DeliveryApp({super.key}) {
    GlobalContext.i.navigatorKey = _navKey;
  }

  @override
  Widget build(BuildContext context) {
    // Poderia colocar o multiProvider aqui sem problemas, porém para manter o código
    // mais organizado, foi implementando na ApplicationBinding;
    return ApplicationBinding(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navKey,
        title: 'Vakinha Burguer',
        theme: ThemeConfig.theme,
        routes: {
          '/': (context) => const SplashPage(),
          '/home': (context) => HomeRouter.page,
          '/productDetail': (context) => ProductDetailRouter.page,
          '/auth/login': (context) => LoginRouter.page,
          '/auth/register': (context) => RegisterRouter.page,
          '/order': (context) => OrderRouter.page,
          '/order/completed': (context) => const OrderCompletedPage(),
        },
      ),
    );
  }
}
