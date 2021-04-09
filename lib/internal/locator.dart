import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:projects/data/api/authentication_api.dart';

import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/api/group_api.dart';
import 'package:projects/data/api/portal_api.dart';
import 'package:projects/data/api/project_api.dart';
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/api/user_api.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/group_service.dart';
import 'package:projects/data/services/portal_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/data/services/storage.dart';
import 'package:projects/data/services/task_service.dart';
import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/groups_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/domain/controllers/tasks/sort_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/domain/controllers/statuses_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/domain/controllers/users/users_controller.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthApi());
  locator.registerLazySingleton(() => CoreApi());
  locator.registerLazySingleton(() => GroupApi());
  locator.registerLazySingleton(() => PortalApi());
  locator.registerLazySingleton(() => ProjectApi());
  locator.registerLazySingleton(() => SecureStorage());
  locator.registerLazySingleton(() => TaskApi());
  locator.registerLazySingleton(() => UserApi());

  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => GroupService());
  locator.registerLazySingleton(() => PortalService());
  locator.registerLazySingleton(() => ProjectService());
  locator.registerLazySingleton(() => TaskItemService());
  locator.registerLazySingleton(() => TaskService());
  locator.registerLazySingleton(() => UserService());

  Get.lazyPut(() => GroupsController(), fenix: false);
  Get.lazyPut(() => NewTaskController(), fenix: false);
  Get.lazyPut(() => ProjectsController());
  Get.lazyPut(() => StatusesController(), fenix: true);
  Get.lazyPut(() => TaskFilterController(), fenix: true);
  Get.lazyPut(() => TaskStatusesController(), fenix: true);
  Get.lazyPut(() => TasksController(), fenix: true);
  Get.lazyPut(() => TasksSortController(), fenix: false);
  Get.lazyPut(() => UserController(), fenix: true);
  Get.lazyPut(() => UsersController(), fenix: true);
}
