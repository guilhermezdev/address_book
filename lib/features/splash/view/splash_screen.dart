import 'package:address_book/features/auth/view/auth/auth_cubit.dart';
import 'package:address_book/features/auth/view/auth/auth_state.dart';
import 'package:address_book/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<AuthCubit>(context).reauth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            router.pushReplacement('/home');
          } else if (state is Unauthenticated) {
            router.pushReplacement('/login');
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Address Book',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(height: 16.0),
              LoadingAnimationWidget.dotsTriangle(
                color: const Color(0xff2E2727),
                size: 48.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
