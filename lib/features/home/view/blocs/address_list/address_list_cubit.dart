import 'package:address_book/common/data/database.dart';
import 'package:address_book/features/home/view/blocs/address_list/address_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddressListCubit extends Cubit<AddressListState> {
  AddressListCubit({
    required this.databaseProvider,
  }) : super(AddressListLoading());

  final DatabaseProvider databaseProvider;

  Future<void> loadAddressList(int userId) async {
    emit(AddressListLoading());

    final addresses = await databaseProvider.findAddresses(userId);

    emit(AddressListSuccess(addresses));
  }
}
