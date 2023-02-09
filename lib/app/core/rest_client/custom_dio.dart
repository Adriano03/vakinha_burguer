import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:vakinha_burguer/app/core/config/env/env.dart';
import 'package:vakinha_burguer/app/core/rest_client/interceptors/auth_interceptor.dart';

class CustomDio extends DioForNative {
  late AuthInterceptor _authInterceptor;

  CustomDio()
      : super(BaseOptions(
          baseUrl: Env.i['backend_base_url'] ?? '',
          connectTimeout: 5000,
          receiveTimeout: 60000,
        )) {
    // Adiciona o interceptador de log à lista de interceptadores
    interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true, 
        requestHeader: true,
        responseHeader: true,
      ),
    );
    _authInterceptor = AuthInterceptor(this);
  }

  // Adiciona o interceptador de autenticação , para poder entrar na tela de order apenas logado;
  CustomDio auth() {
    interceptors.add(_authInterceptor);
    return this;
  }

  // Remove o interceptador da auth, pois o usuário não precisa estar logado para algumas telas;
  CustomDio unAuth() {
    interceptors.remove(_authInterceptor);
    return this;
  }
}
