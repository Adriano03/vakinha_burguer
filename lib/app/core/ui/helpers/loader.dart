import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// Classe mixin são classe que podem ser add a outras classes para herdar suas funcionalidades;.
// Mixin só pode ser usado em local que tenha estado, nesse caso é o StatefulWidget;
mixin Loader<T extends StatefulWidget> on State<T> {
  bool isOpen = false;

  void showLoader() {
    if (!isOpen) {
      isOpen = true;
      showDialog(
        context: context,
        builder: (context) {
          return LoadingAnimationWidget.inkDrop(
            color: Colors.white,
            size: 60,
          );
        },
      );
    }
  }

  void hideLoader() {
    if (isOpen) {
      isOpen = false;
      Navigator.of(context).pop();
    }
  }
}
