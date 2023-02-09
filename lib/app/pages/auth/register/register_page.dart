import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_burguer/app/core/ui/helpers/obscure_password.dart';
import 'package:vakinha_burguer/app/core/ui/base_state/base_state.dart';
import 'package:vakinha_burguer/app/core/ui/helpers/size_extensions.dart';
import 'package:vakinha_burguer/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burguer/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burguer/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_burguer/app/pages/auth/register/register_controller.dart';
import 'package:vakinha_burguer/app/pages/auth/register/register_state.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage, RegisterController> {
  final ObscurePassword obscureP = ObscurePassword();
  final ObscurePassword obscureCp = ObscurePassword();

  final _formKey = GlobalKey<FormState>();

  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  // Enviar dados do formulário para registerController;
  void _submit() {
    final valid = _formKey.currentState!.validate();
    if (!valid) return;
    controller.register(_nameEC.text, _emailEC.text, _passwordEC.text);
  }

  // Quandi não tem rebuild de tela é usado o BlocListener;
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterController, RegisterState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          register: () => showLoader(),
          error: () {
            hideLoader();
            showError('Erro ao registrar usuário');
          },
          success: () {
            hideLoader();
            showSuccess('Cadastro realizado com sucesso');
            Navigator.pop(context);
          },
        );
      },
      child: Scaffold(
        appBar: DeliveryAppbar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cadastro', style: context.textStyles.textTitle),
                  Text(
                    'Preencha os campos abaixo para criar o seu cadastro.',
                    style: context.textStyles.textMedium.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nameEC,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: Validatorless.required('Nome obrigatório.'),
                  ),
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
                        ),
                      ),
                      validator: Validatorless.multiple([
                        Validatorless.required('Senha obrigatório.'),
                        Validatorless.min(6, 'Senha deve conter pelo menos 6.'),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ValueListenableBuilder(
                    valueListenable: obscureCp,
                    builder: (context, value, child) => TextFormField(
                      obscureText: obscureCp.obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Confirma Senha',
                        suffixIcon: IconButton(
                          splashRadius: 1,
                          onPressed: () {
                            obscureCp.toggleObscurePassword();
                          },
                          icon: Icon(
                            obscureCp.obscureConfPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      validator: Validatorless.multiple([
                        Validatorless.required('Confirma Senha obrigatório.'),
                        Validatorless.compare(
                            _passwordEC, 'Senhas não conferem.')
                      ]),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: DeliveryButton(
                      width: context.screenWidth,
                      label: 'CADASTRAR',
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
