import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_burguer/app/core/ui/helpers/obscure_password.dart';
import 'package:vakinha_burguer/app/core/ui/base_state/base_state.dart';
import 'package:vakinha_burguer/app/core/ui/helpers/size_extensions.dart';
import 'package:vakinha_burguer/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burguer/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burguer/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_burguer/app/pages/auth/login/login_controller.dart';
import 'package:vakinha_burguer/app/pages/auth/login/login_state.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage, LoginController> {
  ObscurePassword obscureP = ObscurePassword();
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  void _submit() {
    final valid = _formKey.currentState!.validate();
    if (!valid) return;
    controller.login(_emailEC.text, _passwordEC.text);
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  // Quandi não tem rebuild de tela é usado o BlocListener;
  @override
  Widget build(BuildContext context) {
    // LoginController é usado para controlar o fluxo de informações relacionadas ao processo de login.
    // LoginState representa o estado atual da tela.
    // Ou seja, o BlocListener está escutando o LoginController e reagindo as mudanças no estado LoginState;
    return BlocListener<LoginController, LoginState>(
      listener: (context, state) {
        // Chama o status dentro de LoginState;
        state.status.matchAny(
          any: () => hideLoader(),
          login: () => showLoader(),
          loginError: () {
            hideLoader();
            showError('Login ou senha inválidos');
          },
          error: () {
            hideLoader();
            showError('Erro ao realizar login');
          },
          success: () {
            hideLoader();
            // O true é para afirmar que o usuário fez o login, evitando algum erro caso ele volte para a HomePage;
            Navigator.pop(context, true);
          },
        );
      },
      child: Scaffold(
        appBar: DeliveryAppbar(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Login', style: context.textStyles.textTitle),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _emailEC,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        validator: Validatorless.multiple([
                          Validatorless.required('E-mail obrigatório.'),
                          Validatorless.email('E-mail inválido.'),
                        ]),
                      ),
                      const SizedBox(height: 30),
                      ValueListenableBuilder(
                        valueListenable: obscureP,
                        builder: (context, value, child) => TextFormField(
                          controller: _passwordEC,
                          obscureText: obscureP.obscurePassword,
                          decoration: InputDecoration(
                              labelText: 'Senha',
                              suffixIcon: IconButton(
                                splashRadius: 1,
                                onPressed: () {
                                  obscureP.toggleObscurePassword();
                                },
                                icon: Icon(
                                  obscureP.obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              )),
                          validator: Validatorless.multiple([
                            Validatorless.required('Senha obrigatório.'),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: DeliveryButton(
                          width: context.screenWidth,
                          label: 'ENTRAR',
                          onPressed: _submit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não possui uma conta?',
                        style: context.textStyles.textBold,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/auth/register');
                        },
                        child: Text(
                          'Cadastre-se',
                          style: context.textStyles.textBold.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
