import 'package:address_book/common/domain/viacep_model.dart';

abstract class ViaCepState {}

class ViaCepIdle extends ViaCepState {}

class ViaCepLoading extends ViaCepState {}

class ViaCepSuccess extends ViaCepState {
  final ViaCepModel viapostalCode;

  ViaCepSuccess(this.viapostalCode);
}

class ViaCepFail extends ViaCepState {
  final String error;

  ViaCepFail(this.error);
}
