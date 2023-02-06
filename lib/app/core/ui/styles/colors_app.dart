import 'package:flutter/material.dart';

// Classe utilizando o padrão singleton, faz a classe ter apenas uma instância;
class ColorsApp {
  static ColorsApp? _instance;

  ColorsApp._();

  static ColorsApp get i {
    _instance ??= ColorsApp._();

    return _instance!;
  }

  Color get primary => const Color(0XFF007D21);
  Color get secondary => const Color(0XFFF88B0C);
}

// Essa extensão serve para ter o método chamado pelo context; Ex: context.colors.primary
extension ColorsAppExtensions on BuildContext {
  ColorsApp get colors => ColorsApp.i;
}
