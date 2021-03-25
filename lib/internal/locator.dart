import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:projects/data/api/authentication_api.dart';

import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/api/portal_api.dart';
import 'package:projects/data/api/project_api.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/portal_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/data/services/storage.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/domain/controllers/statuses_controller.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => SecureStorage());
  locator.registerLazySingleton(() => CoreApi());
  locator.registerLazySingleton(() => AuthApi());
  locator.registerLazySingleton(() => PortalApi());
  locator.registerLazySingleton(() => ProjectApi());

  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => PortalService());
  locator.registerLazySingleton(() => ProjectService());

  Get.lazyPut(() => UserController());
  Get.lazyPut(() => StatusesController(), fenix: true);
}
