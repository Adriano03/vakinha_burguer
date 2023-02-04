import 'package:flutter/material.dart';

class DeliveryAppbar extends AppBar {
  final List<Widget>? action;
  DeliveryAppbar({
    super.key,
    this.action,
    double elevation = 1,
  }) : super(
          actions: action,
          elevation: elevation,
          title: Image.asset(
            'assets/images/logo.png',
            width: 80,
          ),
        );
}
