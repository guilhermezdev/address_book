import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> setUpGetIt() async {
  getIt.init();
}
