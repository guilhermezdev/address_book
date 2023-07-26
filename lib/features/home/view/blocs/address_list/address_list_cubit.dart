import 'package:address_book/data/database.dart';
import 'package:address_book/features/home/view/blocs/address_list/address_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressListCubit extends Cubit<AddressListState> {
  AddressListCubit() : super(AddressListLoading());

  final databaseProvider = DatabaseProvider();

  Future<void> loadAddressList(int userId) async {
    emit(AddressListLoading());

    final addresses = await databaseProvider.findAddresses(userId);

    emit(AddressListSuccess(addresses));
  }
}
