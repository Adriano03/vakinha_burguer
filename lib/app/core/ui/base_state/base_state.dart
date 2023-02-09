import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_burguer/app/core/ui/helpers/loader.dart';
import 'package:vakinha_burguer/app/core/ui/helpers/messages.dart';

// C é o tipo de controlador Bloc que será usado com esse estado;
abstract class BaseState<T extends StatefulWidget, C extends BlocBase>
    extends State<T> with Loader, Messages {
  late final C controller;

  @override
  void initState() {
    super.initState();
    // Inicia com o controlador Bloc a partir do contexto;
    controller = context.read<C>();
    // Função de retorno de chamada onReady que será executada após a renderização do widget;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onReady();
    });
  }

  void onReady() {}
}
