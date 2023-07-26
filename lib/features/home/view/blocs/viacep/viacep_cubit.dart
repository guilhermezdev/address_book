import 'package:address_book/data/viacep.dart';
import 'package:address_book/features/home/view/blocs/viacep/viacep_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViaCepCubit extends Cubit<ViaCepState> {
  ViaCepCubit() : super(ViaCepIdle());

  final ViaCepRepository repository = ViaCepRepository();

  Future<void> searchpostalCode(String postalCode) async {
    emit(ViaCepLoading());

    final response = await repository.searchViaCep(postalCode);

    if (response == null) {
      return emit(ViaCepFail('Error searching postalCode information'));
    }

    emit(ViaCepSuccess(response));
  }
}
