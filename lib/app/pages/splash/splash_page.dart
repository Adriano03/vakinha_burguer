import 'package:flutter/material.dart';
import 'package:vakinha_burguer/app/core/ui/helpers/size_extensions.dart';
import 'package:vakinha_burguer/app/core/ui/widgets/delivery_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: orientation == Orientation.portrait
              ? context.screenHeight
              : context.screenHeight,
          child: ColoredBox(
            color: const Color(0XFF140E0E),
            child: Stack(
              children: [
                Visibility(
                  visible: orientation == Orientation.portrait,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: context.screenWidth,
                      child: Image.asset(
                        'assets/images/lanche.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                          height: context.percentHeight(
                              orientation == Orientation.portrait ? .30 : .15)),
                      Image.asset('assets/images/logo.png'),
                      const SizedBox(height: 80),
                      DeliveryButton(
                        width: context.percentWidth(.60),
                        height: 35,
                        label: 'ACESSAR',
                        onPressed: () {
                          Navigator.of(context).popAndPushNamed('/home');
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
