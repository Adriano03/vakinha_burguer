import 'package:flutter/material.dart';
import 'package:vakinha_burguer/app/core/provider/application_binding.dart';
import 'package:vakinha_burguer/app/core/ui/theme/theme_config.dart';
import 'package:vakinha_burguer/app/pages/home/home_router.dart';
import 'package:vakinha_burguer/app/pages/splash/splash_page.dart';

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ApplicationBinding(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vakinha Burguer',
        theme: ThemeConfig.theme,
        routes: {
          '/': (context) => const SplashPage(),
          '/home': (context) => HomeRouter.page,
        },
      ),
    );
  }
}
