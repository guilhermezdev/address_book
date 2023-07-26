import 'package:address_book/domain/address_model.dart';
import 'package:address_book/features/edit_address/view/edit_address_screen.dart';
import 'package:address_book/features/home/view/home_screen.dart';
import 'package:address_book/features/login/view/login_screen.dart';
import 'package:address_book/features/new_address/view/new_address_screen.dart';
import 'package:address_book/features/profile/view/profile_screen.dart';
import 'package:address_book/features/sign_up/view/sign_up_screen.dart';
import 'package:address_book/features/splash/view/splash_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/new-address',
      builder: (context, state) => const NewAddressScreen(),
    ),
    GoRoute(
      path: '/edit-address',
      builder: (context, state) =>
          EditAddressScreen(address: state.extra as AddressModel),
    ),
  ],
);
