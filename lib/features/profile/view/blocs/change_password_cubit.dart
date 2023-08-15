import 'package:address_book/common/data/database.dart';
import 'package:address_book/common/domain/user_model.dart';
import 'package:address_book/features/profile/view/blocs/change_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordIdle());

  final DatabaseProvider databaseProvider = DatabaseProvider();

  Future<void> changePassword(UserModel user) async {
    await databaseProvider.updateUser(user);

    emit(ChangePasswordSuccess(user));
  }
}
