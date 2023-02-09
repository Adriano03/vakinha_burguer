import 'package:provider/provider.dart';
import 'package:vakinha_burguer/app/pages/auth/login/login_controller.dart';
import 'package:vakinha_burguer/app/pages/auth/login/login_page.dart';

class LoginRouter {
  LoginRouter._();

  static get page => MultiProvider(
        providers: [
          Provider(
            // read() é usado para acessar um provedor que foi passado no escopop superior. Ou seja o loginController está tentando
            // ler uma instância de AuthRepository que foi passado como Provider global em ApplicationBinding;
            create: (context) => LoginController(context.read()),
          ),
        ],
        child: const LoginPage(),
      );
}
