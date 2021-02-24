import 'package:get_it/get_it.dart';
import 'package:only_office_mobile/data/api/authentication_api.dart';

import 'package:only_office_mobile/data/api/core_api.dart';
import 'package:only_office_mobile/data/services/authentication_service.dart';
import 'package:only_office_mobile/domain/viewmodels/home_viewmodel.dart';
import 'package:only_office_mobile/domain/viewmodels/login_viewmodel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => CoreApi());
  locator.registerLazySingleton(() => AuthApi());
  locator.registerLazySingleton(() => AuthenticationService());

  locator.registerFactory(() => LoginViewModel());
  locator.registerFactory(() => HomeViewModel());
}
