import 'package:address_book/common/data/database.dart';
import 'package:address_book/features/auth/view/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  final databaseProvider = DatabaseProvider();

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    final user = await databaseProvider.findUserByEmail(email);

    await Future.delayed(const Duration(seconds: 2));

    if (user == null || user.password != password) {
      return emit(LoginFailed('User and/or password is incorrect'));
    }

    emit(LoginSuccess(user));
  }
}
