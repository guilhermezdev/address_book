import 'package:address_book/common/domain/user_model.dart';

abstract class SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpSuccess extends SignUpInitialState {
  final UserModel user;

  SignUpSuccess(this.user);
}

class SignUpFailed extends SignUpInitialState {
  final String error;

  SignUpFailed(this.error);
}

class SignUpLoading extends SignUpInitialState {}
