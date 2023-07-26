import 'package:address_book/domain/user_model.dart';
import 'package:address_book/features/auth/view/auth/auth_cubit.dart';
import 'package:address_book/features/auth/view/auth/auth_state.dart';
import 'package:address_book/features/profile/view/blocs/change_password_cubit.dart';
import 'package:address_book/features/profile/view/blocs/change_password_state.dart';
import 'package:address_book/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _newPasswordController;

  late final UserModel user;

  final _formKey = GlobalKey<FormState>();

  late final ChangePasswordCubit changePasswordCubit;

  late bool showPassword;
  late bool showConfirmPassword;

  @override
  void initState() {
    super.initState();
    user = (context.read<AuthCubit>().state as Authenticated).user;

    _nomeController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _passwordController = TextEditingController();
    _newPasswordController = TextEditingController();

    changePasswordCubit = ChangePasswordCubit();

    showPassword = true;
    showConfirmPassword = true;
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        bloc: changePasswordCubit,
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            context.read<AuthCubit>().updateUser(state.user);
            router.pop();
            const snackbar = SnackBar(
              content: Text('Password updated!'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
                icon: const Icon(Icons.logout_outlined),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _nomeController,
                      enabled: false,
                      decoration: const InputDecoration(
                        label: Text('Name'),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      enabled: false,
                      decoration: const InputDecoration(
                        label: Text('Email'),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: showPassword,
                      decoration: InputDecoration(
                        label: const Text(
                          'Current password',
                        ),
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
                      controller: _newPasswordController,
                      obscureText: showConfirmPassword,
                      decoration: InputDecoration(
                        label: const Text('New password'),
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

                        return null;
                      },
                    ),
                    const SizedBox(height: 64.0),
                    ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formKey.currentState!.validate()) {
                          if (_passwordController.text.trim() !=
                              user.password) {
                            const snackbar = SnackBar(
                              content: Text('Current password is incorrect'),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          } else {
                            final newUser = user.copyWithPassword(
                                _newPasswordController.text.trim());

                            changePasswordCubit.changePassword(newUser);
                          }
                        }
                      },
                      child: const Text('Change password'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
