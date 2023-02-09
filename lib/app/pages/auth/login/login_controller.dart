import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakinha_burguer/app/core/exceptions/unauthorized_exceptions.dart';
import 'package:vakinha_burguer/app/pages/auth/login/login_state.dart';
import 'package:vakinha_burguer/app/repositories/auth/auth_repository.dart';

class LoginController extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginController(this._authRepository) : super(const LoginState.initial());
  // Dados passados por parâmetro de loginPage na função _submit;
  Future<void> login(String email, String password) async {
    try {
      // Emite um novo estado com o LoginStatus.login;
      emit(state.copyWith(status: LoginStatus.login));
      final authMode = await _authRepository.login(email, password);
      // Com login feito a variável vai guardar o token;
      final sp = await SharedPreferences.getInstance();
      // Guardar accessToken na sp para fazer a verificação para qual página o usuário logado vai ser redirecionadoauth ou order;
      sp.setString('accessToken', authMode.accessToken);
      // Guardar refreshToken que vem da api na sp para manter o usuário logado pelo tempo determinado na api;
      sp.setString('refreshToken', authMode.refreshToken);
      // Se tudo ocorreu bem emite LoginStatus.success;
      emit(state.copyWith(status: LoginStatus.success));
      // Tratamento para email ou senha inválidos;
    } on UnauthorizedExceptions catch (e, s) {
      emit(state.copyWith(
          status: LoginStatus.loginError,
          errorMessage: 'Login ou senha inválidos'));
      log('Login ou senha inválidos', error: e, stackTrace: s);
    } catch (e, s) {
      emit(state.copyWith(
          status: LoginStatus.error, errorMessage: 'Erros ao realizar login'));
      log('Erro ao realizar login', error: e, stackTrace: s);
    }
  }
}
