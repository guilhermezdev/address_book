import 'package:address_book/common/data/database.dart';
import 'package:address_book/common/domain/user_model.dart';
import 'package:address_book/features/auth/view/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(Unauthenticated());

  final DatabaseProvider databaseProvider = DatabaseProvider();

  Future<void> reauth() async {
    emit(AuthLoading());

    final prefs = await SharedPreferences.getInstance();

    final int? lastLogin = prefs.getInt('lastLogin');

    await Future.delayed(const Duration(seconds: 4));

    if (lastLogin == null) {
      return emit(Unauthenticated());
    }

    final user = await databaseProvider.findUserById(lastLogin);

    if (user == null) {
      return emit(Unauthenticated());
    }

    emit(Authenticated(user));
  }

  Future<void> persistUser(UserModel user) async {
    emit(Authenticated(user));

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastLogin', user.id!);
  }

  Future<void> updateUser(UserModel user) async {
    emit(Authenticated(user));
  }

  Future<void> logout() async {
    emit(Unauthenticated());

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('lastLogin');
  }
}
