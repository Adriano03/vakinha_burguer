import 'package:flutter/material.dart';

extension SizeExtensions on BuildContext {
  // Para usar em qualquer tela, é só chamar pelo context Ex:(context.screenWidth)
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  double percentWidth(double percent) => screenWidth * percent;
  double percentHeight(double percent) => screenHeight * percent;

}
