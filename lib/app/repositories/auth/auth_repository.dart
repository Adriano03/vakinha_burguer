import 'package:vakinha_burguer/app/models/auth_model.dart';

abstract class AuthRepository {
  //Registrar
  Future<void> register(String name, String email, String password);
  //Login
  Future<AuthModel> login(String email, String password);
}
