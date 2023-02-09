
import 'package:flutter/material.dart';

class ObscurePassword extends ValueNotifier<bool>{

  ObscurePassword() : super(true);

  bool get obscurePassword => value;
  bool get obscureConfPassword => value;

  void toggleObscurePassword() {
    value = !value;
    notifyListeners();
  }
}