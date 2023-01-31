import 'package:flutter/material.dart';
import 'package:vakinha_burguer/app/core/config/env/env.dart';
import 'package:vakinha_burguer/app/delivery_app.dart';

Future<void> main() async {
  await Env.i.load();

  runApp(const DeliveryApp());
}
