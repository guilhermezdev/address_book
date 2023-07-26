import 'package:address_book/features/auth/view/auth/auth_cubit.dart';
import 'package:address_book/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthCubit authCubit;
  @override
  void initState() {
    super.initState();

    authCubit = AuthCubit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => authCubit,
      child: MaterialApp.router(
        title: 'Personal Address Book',
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
          appBarTheme: const AppBarTheme(
            color: Color(0xff241C1C),
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffD0CDC2),
            background: const Color(0xffE6E3DD),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff241C1C),
              surfaceTintColor: Colors.white,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
