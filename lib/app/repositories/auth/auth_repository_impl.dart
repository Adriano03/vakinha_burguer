import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:vakinha_burguer/app/core/exceptions/repository_exception.dart';
import 'package:vakinha_burguer/app/core/exceptions/unauthorized_exceptions.dart';
import 'package:vakinha_burguer/app/core/rest_client/custom_dio.dart';
import 'package:vakinha_burguer/app/models/auth_model.dart';

import './auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final CustomDio dio;

  AuthRepositoryImpl({
    required this.dio,
  });

  // Login
  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      final result = await dio.unAuth().post('/auth', data: {
        'email': email,
        'password': password,
      });

      return AuthModel.fromMap(result.data);
    } on DioError catch (e, s) {
      if (e.response?.statusCode == 403) {
        log('E-mail ou senha inválido', error: e, stackTrace: s);
        throw UnauthorizedExceptions();
      }

      log('Erro ao realizar Login', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao realizar Login');
    }
  }

  //Registrar
  @override
  Future<void> register(String name, String email, String password) async {
    try {
      await dio.unAuth().post('/users', data: {
        'name': name,
        'email': email,
        'password': password,
      });
    } on DioError catch (e, s) {
      log('Erro ao realizar cadastro', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao registrar usuário');
    }
  }
}
