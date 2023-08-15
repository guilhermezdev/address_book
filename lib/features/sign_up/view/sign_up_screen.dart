import 'package:address_book/common/domain/user_model.dart';
import 'package:address_book/common/view/loading_widget.dart';
import 'package:address_book/di.dart';
import 'package:address_book/features/auth/view/auth/auth_cubit.dart';
import 'package:address_book/features/auth/view/auth/auth_state.dart';
import 'package:address_book/features/auth/view/sign_up/sign_up_cubit.dart';
import 'package:address_book/features/auth/view/sign_up/sign_up_state.dart';
import 'package:address_book/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late SignUpCubit signUpCubit;

  late bool showPassword;
  late bool showConfirmPassword;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    signUpCubit = SignUpCubit();

    showPassword = true;
    showConfirmPassword = true;
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

  void toggleShowConfirmPassword() {
    setState(() {
      showConfirmPassword = !showConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up for yor Address Book'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: BlocListener<AuthCubit, AuthState>(
          bloc: getIt<AuthCubit>(),
          listener: (context, state) {
            if (state is Authenticated) {
              router.pushReplacement('/home');
            }
          },
          child: BlocListener<SignUpCubit, SignUpState>(
            bloc: signUpCubit,
            listener: (context, state) {
              if (state is SignUpSuccess) {
                getIt<AuthCubit>().persistUser(state.user);
              }

              if (state is SignUpFailed) {
                final snackbar = SnackBar(content: Text(state.error));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required field';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Email'),
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
                        textInputAction: TextInputAction.next,
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
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: showConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm password',
                          suffixIcon: !showConfirmPassword
                              ? IconButton(
                                  onPressed: toggleShowConfirmPassword,
                                  icon: const Icon(
                                    Icons.visibility_off,
                                  ),
                                )
                              : IconButton(
                                  onPressed: toggleShowConfirmPassword,
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

                          if (value.trim() != _passwordController.text.trim()) {
                            return 'The passwords do not match';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 64.0),
                      BlocBuilder<SignUpCubit, SignUpState>(
                        bloc: signUpCubit,
                        builder: (context, state) {
                          if (state is SignUpLoading) {
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
                                final user = UserModel(
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                                signUpCubit.signUp(user);
                              }
                            },
                            child: const Text('Sign up'),
                          );
                        },
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
