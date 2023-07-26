import 'package:address_book/domain/address_model.dart';

abstract class AddressListState {}

class AddressListSuccess extends AddressListState {
  final List<AddressModel> addresses;

  AddressListSuccess(this.addresses);
}

class AddressListFail extends AddressListState {
  final String error;

  AddressListFail(this.error);
}

class AddressListLoading extends AddressListState {}
