import 'package:address_book/common/data/database.dart';
import 'package:address_book/common/domain/address_model.dart';
import 'package:address_book/features/home/view/blocs/manipulate_address/manipulate_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ManipulateAddressCubit extends Cubit<ManipulateAddressState> {
  ManipulateAddressCubit({
    required this.databaseProvider,
  }) : super(ManipulateAddressIdle());

  final DatabaseProvider databaseProvider;

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
