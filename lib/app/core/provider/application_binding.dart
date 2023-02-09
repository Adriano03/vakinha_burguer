import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vakinha_burguer/app/core/rest_client/custom_dio.dart';
import 'package:vakinha_burguer/app/repositories/auth/auth_repository.dart';
import 'package:vakinha_burguer/app/repositories/auth/auth_repository_impl.dart';

// Aqui fica todas as instâncias que é utilizada em mais de um local da aplicação para evitar a duplicaçãod de código;

class ApplicationBinding extends StatelessWidget {
  final Widget child;

  const ApplicationBinding({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => CustomDio(),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            // Função para acessar provedores de dados. Nesse exemplo o CustomDio é fornecido como provedor e depois lido usando
            // o context.read() assim fornecendo a instância Custom dio para AuthRepositoryImpl;1
            dio: context.read(),
          ),
        ),
      ],
      child: child,
    );
  }
}
