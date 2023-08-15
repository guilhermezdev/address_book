import 'package:address_book/di.dart';
import 'package:address_book/router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpGetIt();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData get theme => ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
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
      );

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Personal Address Book',
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: theme,
      );
}
