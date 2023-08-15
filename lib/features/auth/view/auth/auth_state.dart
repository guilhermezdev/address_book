import 'package:address_book/common/domain/user_model.dart';

abstract class AuthState {}

class Authenticated extends AuthState {
  final UserModel user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthLoading extends AuthState {}
