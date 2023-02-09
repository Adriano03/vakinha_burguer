import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:vakinha_burguer/app/pages/auth/register/register_state.dart';
import 'package:vakinha_burguer/app/repositories/auth/auth_repository.dart';

class RegisterController extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterController(this._authRepository)
      : super(const RegisterState.initial());
  // Dados vindo do botão submit em registerPage;
  Future<void> register(String name, String email, String password) async {
    try {
      // Emitindo evento para indicar que o RegisterStatus.register começou;
      emit(state.copyWith(status: RegisterStatus.register));
      // Passando para register em authRepository;
      await _authRepository.register(name, email, password);
      // Emitindo evento para indicar que o RegisterStatus.success foi bem sucedido;
      emit(state.copyWith(status: RegisterStatus.success));
    } catch (e, s) {
      log('Erro ao registrar usuário', error: e, stackTrace: s);
      // Emitindo evento para indicar que o RegisterStatus.error foi bem sucedido;
      emit(state.copyWith(status: RegisterStatus.error));
    }
  }
}
