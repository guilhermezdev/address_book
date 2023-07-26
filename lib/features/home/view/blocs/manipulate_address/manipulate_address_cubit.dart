import 'package:address_book/data/database.dart';
import 'package:address_book/domain/address_model.dart';
import 'package:address_book/features/home/view/blocs/manipulate_address/manipulate_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManipulateAddressCubit extends Cubit<ManipulateAddressState> {
  ManipulateAddressCubit() : super(ManipulateAddressIdle());

  final DatabaseProvider databaseProvider = DatabaseProvider();

  Future<void> addAddress(AddressModel address) async {
    await databaseProvider.insertAddress(address);

    emit(ManipulateAddressAddSuccess());
  }

  Future<void> removeAddress(int addressId) async {
    await databaseProvider.removeAddress(addressId);

    emit(ManipulateAddressRemoveSuccess());
  }

  Future<void> updateAddress(AddressModel address) async {
    await databaseProvider.updateAddress(address);

    emit(ManipulateAddressEditSuccess());
  }
}
