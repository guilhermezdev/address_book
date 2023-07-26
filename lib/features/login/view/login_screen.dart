import 'package:address_book/common/loading_widget.dart';
import 'package:address_book/features/auth/view/auth/auth_cubit.dart';
import 'package:address_book/features/auth/view/auth/auth_state.dart';
import 'package:address_book/features/auth/view/login/login_cubit.dart';
import 'package:address_book/features/auth/view/login/login_state.dart';
import 'package:address_book/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late bool showPassword;

  late LoginCubit loginCubit;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    loginCubit = LoginCubit();

    showPassword = true;
  }

  bool checkEmailValid(String email) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return regex.hasMatch(email);
  }

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: MultiBlocListener(
              listeners: [
                BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is Authenticated) {
                      router.pushReplacement('/home');
                    }
                  },
                ),
                BlocListener<LoginCubit, LoginState>(
                  bloc: loginCubit,
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      BlocProvider.of<AuthCubit>(context)
                          .persistUser(state.user);
                    } else if (state is LoginFailed) {
                      final snackbar = SnackBar(content: Text(state.error));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  },
                ),
              ],
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 64.0,
                      ),
                      const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'to enter your Addresses Collection',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required field';
                          }

                          if (!checkEmailValid(value)) {
                            return 'Invalid email format';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: showPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: !showPassword
                              ? IconButton(
                                  onPressed: toggleShowPassword,
                                  icon: const Icon(
                                    Icons.visibility_off,
                                  ),
                                )
                              : IconButton(
                                  onPressed: toggleShowPassword,
                                  icon: const Icon(
                                    Icons.visibility,
                                  ),
                                ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required field';
                          }

                          if (value.trim().length < 8) {
                            return 'Min 8 characters';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 48.0),
                      BlocBuilder<LoginCubit, LoginState>(
                        bloc: loginCubit,
                        builder: (context, state) {
                          if (state is LoginLoading) {
                            return const Center(
                              child: LoadingWidget(),
                            );
                          }

                          return ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              final validate =
                                  _formKey.currentState!.validate();

                              if (validate) {
                                loginCubit.login(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                              }
                            },
                            child: const Text('Continue'),
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                      OutlinedButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                          FocusManager.instance.primaryFocus?.unfocus();
                          router.push('/sign-up');
                        },
                        child: const Text('Sign up'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
