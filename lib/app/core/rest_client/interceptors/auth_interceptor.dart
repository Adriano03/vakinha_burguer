import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakinha_burguer/app/core/exceptions/expire_token_exception.dart';

import 'package:vakinha_burguer/app/core/global/global_context.dart';
import 'package:vakinha_burguer/app/core/rest_client/custom_dio.dart';

class AuthInterceptor extends Interceptor {
  final CustomDio dio;

  AuthInterceptor(this.dio);

  // O onRequest é executado antes de cada requisição da api, e adiciona o token de autorização ao cabeçalho da requisição;
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Buscar o token do usuário logado armazenado localmente.
    final sp = await SharedPreferences.getInstance();
    final accessToken = sp.getString('accessToken');
    // Adicionar token ao header (cabeçalho da autorização);
    options.headers['Authorization'] = 'Bearer $accessToken';
    // Encainha a requisição para o próximo manipulador;
    handler.next(options);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        if (err.requestOptions.path != '/auth/refresh') {
          await _refreshToken(err);
          await _retryRequest(err, handler);
        } else {
          // Se o login estiver expirado redirecionar o usuário para a tela de home;
          GlobalContext.i.loginExpire();
        }
      } catch (e) {
        GlobalContext.i.loginExpire();
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> _refreshToken(DioError err) async {
    try {
      final sp = await SharedPreferences.getInstance();
      // Recupera o refreshToken armazenado;
      final refreshToken = sp.getString('refreshToken');

      if (refreshToken == null) return;
      // Realiza a requisição para refresh do token;
      final resultRefresh = await dio.auth().put('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });
      // Armazena novo accessToken e refreshToken;
      sp.setString('accessToken', resultRefresh.data['access_token']);
      sp.setString('refreshToken', resultRefresh.data['refresh_token']);
    } on DioError catch (e, s) {
      log('Erro ao realizar refresh token', error: e, stackTrace: s);
      throw ExpireTokenException();
    }
  }

  Future<void> _retryRequest(
      DioError err, ErrorInterceptorHandler handler) async {
    // Recupera as informações da requisição original que deu erro;
    final requestOptions = err.requestOptions;
    // Realiza novamente a requisição com as informações da requisição original;
    final result = await dio.request(
      requestOptions.path,
      options: Options(
        headers: requestOptions.headers,
        method: requestOptions.method,
      ),
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
    // Resolve a requisição com as informações da requisição;
    handler.resolve(
      Response(
        requestOptions: requestOptions,
        data: result.data,
        statusCode: result.statusCode,
        statusMessage: result.statusMessage,
      ),
    );
  }
}
