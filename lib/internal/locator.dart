import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:projects/data/api/authentication_api.dart';
import 'package:projects/data/api/comments_api.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/api/discussions_api.dart';
import 'package:projects/data/api/download_api.dart';
import 'package:projects/data/api/files_api.dart';
import 'package:projects/data/api/group_api.dart';
import 'package:projects/data/api/milestone_api.dart';
import 'package:projects/data/api/portal_api.dart';
import 'package:projects/data/api/project_api.dart';
import 'package:projects/data/api/subtasks_api.dart';
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/api/user_api.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/discussion_item_service.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/data/services/group_service.dart';
import 'package:projects/data/services/local_authentication_service.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/data/services/numbers_service.dart';
import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/data/services/portal_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/data/services/settings_service.dart';
import 'package:projects/data/services/sms_code_service.dart';
import 'package:projects/data/services/storage.dart';
import 'package:projects/data/services/subtasks_service.dart';
import 'package:projects/data/services/task_item_service.dart';
import 'package:projects/data/services/task_service.dart';
import 'package:projects/data/services/user_service.dart';

import 'package:projects/domain/controllers/comments/comments_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_filter_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_sort_controller.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/documents/documents_filter_controller.dart';
import 'package:projects/domain/controllers/documents/documents_move_or_copy_controller.dart';
import 'package:projects/domain/controllers/documents/documents_sort_controller.dart';
import 'package:projects/domain/controllers/documents/discussions_documents_controller.dart';
import 'package:projects/domain/controllers/groups_controller.dart';
import 'package:projects/domain/controllers/milestones/milestones_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';

import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_data_source.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_filter_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_sort_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/new_milestone_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_tasks_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/groups_data_source.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/domain/controllers/projects/project_status_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/domain/controllers/users/users_controller.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthApi());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => CommentsApi());
  locator.registerLazySingleton(() => CommentsService());
  locator.registerLazySingleton(() => CoreApi());
  locator.registerLazySingleton(() => DiscussionsApi());
  locator.registerLazySingleton(() => DiscussionItemService());
  locator.registerLazySingleton(() => DiscussionsService());
  locator.registerLazySingleton(() => DownloadApi());
  locator.registerLazySingleton(() => DownloadService());
  locator.registerLazySingleton(() => FilesApi());
  locator.registerLazySingleton(() => FilesService());
  locator.registerLazySingleton(() => GroupApi());
  locator.registerLazySingleton(() => GroupService());
  locator.registerLazySingleton(() => LocalAuthenticationService());
  locator.registerLazySingleton(() => MilestoneApi());
  locator.registerLazySingleton(() => MilestoneService());
  locator.registerLazySingleton(() => NumbersService());
  locator.registerLazySingleton(() => PasscodeService());
  locator.registerLazySingleton(() => PortalApi());
  locator.registerLazySingleton(() => PortalService());
  locator.registerLazySingleton(() => ProjectApi());
  locator.registerLazySingleton(() => ProjectService());
  locator.registerLazySingleton(() => SecureStorage());
  locator.registerLazySingleton(() => SubtasksApi());
  locator.registerLazySingleton(() => SubtasksService());
  locator.registerLazySingleton(() => SettingsService());
  locator.registerLazySingleton(() => SmsCodeService());
  locator.registerLazySingleton(() => TaskApi());
  locator.registerLazySingleton(() => TaskItemService());
  locator.registerLazySingleton(() => TaskService());
  locator.registerLazySingleton(() => UserApi());
  locator.registerLazySingleton(() => UserService());

  Get.lazyPut(() => PlatformController());
  Get.lazyPut(() => NavigationController(), fenix: true);
  Get.lazyPut(() => CommentsController(), fenix: true);
  Get.lazyPut(() => DiscussionsSortController(), fenix: true);
  Get.lazyPut(() => DiscussionsFilterController(), fenix: true);
  Get.lazyPut(
    () => DiscussionsController(
      Get.find<DiscussionsFilterController>(),
      Get.put(PaginationController(), tag: 'DiscussionsController'),
    ),
    fenix: true,
  );
  Get.lazyPut(() => GroupsController(), fenix: true);
  Get.lazyPut(() => MilestonesController(), fenix: true);
  Get.lazyPut(() => NewTaskController(), fenix: true);

  Get.lazyPut(() => TaskFilterController(), fenix: true);
  Get.lazyPut(() => TaskStatusesController(), fenix: true);

  Get.lazyPut(
      () => TasksController(
            Get.find<TaskFilterController>(),
            Get.put(PaginationController(), tag: 'TasksController'),
          ),
      fenix: true);

  Get.lazyPut(() => TasksSortController(), fenix: true);
  Get.lazyPut(() => UserController(), fenix: true);
  Get.lazyPut(() => UsersController(), fenix: true);

  Get.lazyPut(() => UsersDataSource(), fenix: true);
  Get.lazyPut(() => GroupsDataSource(), fenix: true);

  Get.lazyPut(() => ProjectStatusesController(), fenix: true);
  Get.lazyPut(() => ProjectTasksController(), fenix: true);
  Get.lazyPut(() => ProjectsFilterController(), fenix: true);
  Get.lazyPut(() => MilestonesDataSource(), fenix: true);

  Get.lazyPut(() => MilestonesSortController(), fenix: true);
  Get.lazyPut(() => MilestonesFilterController(), fenix: true);

  Get.lazyPut(() => NewMilestoneController(), fenix: true);
  Get.lazyPut(() => PortalInfoController(), fenix: true);

  Get.create<DocumentsFilterController>(() => DocumentsFilterController());
  Get.create<PaginationController>(() => PaginationController());

  Get.create<ProjectsSortController>(() => ProjectsSortController());
  Get.create<DocumentsSortController>(() => DocumentsSortController());

  Get.create<DocumentsController>(() => DocumentsController(
        Get.find<DocumentsFilterController>(),
        Get.find<PaginationController>(),
        Get.find<DocumentsSortController>(),
      ));
  Get.create<DocumentsMoveOrCopyController>(() => DocumentsMoveOrCopyController(
        Get.find<DocumentsFilterController>(),
        Get.find<PaginationController>(),
        Get.find<DocumentsSortController>(),
      ));

  Get.create<DiscussionsDocumentsController>(
      () => DiscussionsDocumentsController(
            Get.find<DocumentsFilterController>(),
            Get.find<PaginationController>(),
            Get.find<DocumentsSortController>(),
          ));

  Get.lazyPut(
      () => ProjectsController(
            Get.put(ProjectsFilterController(), tag: 'ProjectsView'),
            Get.put(PaginationController(), tag: 'ProjectsView'),
          ),
      tag: 'ProjectsView');
}
