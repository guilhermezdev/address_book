// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:address_book/common/data/database.dart' as _i4;
import 'package:address_book/common/data/viacep.dart' as _i8;
import 'package:address_book/features/auth/view/auth/auth_cubit.dart' as _i3;
import 'package:address_book/features/auth/view/login/login_cubit.dart' as _i5;
import 'package:address_book/features/auth/view/sign_up/sign_up_cubit.dart'
    as _i7;
import 'package:address_book/features/home/view/blocs/address_list/address_list_cubit.dart'
    as _i9;
import 'package:address_book/features/home/view/blocs/manipulate_address/manipulate_address_cubit.dart'
    as _i6;
import 'package:address_book/features/home/view/blocs/viacep/viacep_cubit.dart'
    as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.AuthCubit>(_i3.AuthCubit());
    gh.singleton<_i4.DatabaseProvider>(_i4.DatabaseProvider());
    gh.factory<_i5.LoginCubit>(() => _i5.LoginCubit());
    gh.factory<_i6.ManipulateAddressCubit>(() => _i6.ManipulateAddressCubit(
        databaseProvider: gh<_i4.DatabaseProvider>()));
    gh.factory<_i7.SignUpCubit>(() => _i7.SignUpCubit());
    gh.factory<_i8.ViaCepRepository>(() => _i8.ViaCepRepository());
    gh.factory<_i9.AddressListCubit>(() =>
        _i9.AddressListCubit(databaseProvider: gh<_i4.DatabaseProvider>()));
    gh.factory<_i10.ViaCepCubit>(
        () => _i10.ViaCepCubit(repository: gh<_i8.ViaCepRepository>()));
    return this;
  }
}
