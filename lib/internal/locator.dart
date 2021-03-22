import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:only_office_mobile/data/api/authentication_api.dart';

import 'package:only_office_mobile/data/api/core_api.dart';
import 'package:only_office_mobile/data/api/portal_api.dart';
import 'package:only_office_mobile/data/api/project_api.dart';
import 'package:only_office_mobile/data/services/authentication_service.dart';
import 'package:only_office_mobile/data/services/portal_service.dart';
import 'package:only_office_mobile/data/services/project_service.dart';
import 'package:only_office_mobile/data/services/storage.dart';
import 'package:only_office_mobile/domain/controllers/user_controller.dart';
import 'package:only_office_mobile/domain/controllers/statuses_controller.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Storage());
  locator.registerLazySingleton(() => CoreApi());
  locator.registerLazySingleton(() => AuthApi());
  locator.registerLazySingleton(() => PortalApi());
  locator.registerLazySingleton(() => ProjectApi());

  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => PortalService());
  locator.registerLazySingleton(() => ProjectService());

  Get.lazyPut(() => UserController());
  Get.lazyPut(() => StatusesController());
}
