import 'package:get_it/get_it.dart';
import 'package:only_office_mobile/data/api/authentication_api.dart';

import 'package:only_office_mobile/data/api/core_api.dart';
import 'package:only_office_mobile/data/api/portal_api.dart';
import 'package:only_office_mobile/data/services/authentication_service.dart';
import 'package:only_office_mobile/data/services/portal_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => CoreApi());
  locator.registerLazySingleton(() => AuthApi());
  locator.registerLazySingleton(() => PortalApi());

  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => PortalService());
}
