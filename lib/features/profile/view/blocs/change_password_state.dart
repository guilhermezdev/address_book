import 'package:address_book/common/domain/user_model.dart';

abstract class ChangePasswordState {}

class ChangePasswordIdle extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final UserModel user;

  ChangePasswordSuccess(this.user);
}

class ChangePasswordFailed extends ChangePasswordState {}
