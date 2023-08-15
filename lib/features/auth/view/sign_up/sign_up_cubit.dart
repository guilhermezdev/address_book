import 'package:address_book/common/data/database.dart';
import 'package:address_book/common/domain/user_model.dart';
import 'package:address_book/features/auth/view/sign_up/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitialState());

  final databaseProvider = DatabaseProvider();

  Future<void> signUp(UserModel newUser) async {
    emit(SignUpLoading());
    final users = await databaseProvider.findUsers();

    await Future.delayed(const Duration(seconds: 2));

    if (users.any((element) => element.email == newUser.email)) {
      return emit(SignUpFailed('Email already registered in database'));
    }

    final newId = await databaseProvider.insertUser(newUser);

    return emit(SignUpSuccess(newUser.copyWithId(newId)));
  }
}
