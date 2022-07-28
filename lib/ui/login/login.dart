import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_accounting/business/bloc/auth/auth_bloc.dart';
import 'package:personal_accounting/business/functions/handles.dart';
import 'package:personal_accounting/business/functions/validate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _login = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/images/Gradient 1.png',
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FittedBox(
                      child: Text(
                        'Учёт расходов',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      width: 350,
                      child: Text(
                        'Ваша история расходов всегда под рукой',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _email,
                          style: Theme.of(context).textTheme.bodyText2,
                          decoration: const InputDecoration(
                            labelText: "E-mail",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Введите E-mail';
                            if (!validateEmail(value.toString())) {
                              return 'Некорректный E-mail';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: _password,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Введите пароль';
                            return null;
                          },
                          style: Theme.of(context).textTheme.bodyText2,
                          decoration: const InputDecoration(
                            labelText: "Пароль",
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                state is AuthAwait
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            _formKey.currentState!.save();
                                            if (_login) {
                                              BlocProvider.of<AuthBloc>(context).add(AuthAuthentification(_email.text, _password.text));
                                            } else {
                                              BlocProvider.of<AuthBloc>(context).add(AuthRegistration(_email.text, _password.text));
                                            }
                                          }
                                        },
                                        child: Text(_login ? 'Войти' : 'Регистрация'),
                                      ),
                                const SizedBox(
                                  height: 30,
                                ),
                                state is AuthError
                                    ? Text(
                                        authMessages(state.error.toString()),
                                        style: Theme.of(context).textTheme.subtitle2,
                                      )
                                    : const SizedBox()
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_login ? 'Еще нет аккаунта? ' : 'Уже есть аккаунт'),
                    TextButton(
                      onPressed: () => setState(() => _login = !_login),
                      child: Text(_login ? 'Регистрация' : 'Войти'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
