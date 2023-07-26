import 'package:address_book/domain/user_model.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginSuccess extends LoginState {
  final UserModel user;

  LoginSuccess(this.user);
}

class LoginFailed extends LoginState {
  final String error;

  LoginFailed(this.error);
}

class LoginLoading extends LoginState {}
