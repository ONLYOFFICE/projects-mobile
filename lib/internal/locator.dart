/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:projects/data/api/authentication_api.dart';
import 'package:projects/data/api/comments_api.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/api/download_api.dart';
import 'package:projects/data/api/files_api.dart';
import 'package:projects/data/api/group_api.dart';
import 'package:projects/data/api/milestone_api.dart';
import 'package:projects/data/api/portal_api.dart';
import 'package:projects/data/api/project_api.dart';
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/api/user_api.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/data/services/group_service.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/data/services/portal_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/data/services/storage.dart';
import 'package:projects/data/services/task_item_service.dart';
import 'package:projects/data/services/task_service.dart';
import 'package:projects/data/services/user_service.dart';

import 'package:projects/domain/controllers/comments/comments_controller.dart';
import 'package:projects/domain/controllers/groups_controller.dart';
import 'package:projects/domain/controllers/milestones/milestones_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_tasks_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/groups_data_source.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
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
  locator.registerLazySingleton(() => CoreApi());
  locator.registerLazySingleton(() => CommentsApi());
  locator.registerLazySingleton(() => FilesApi());
  locator.registerLazySingleton(() => GroupApi());
  locator.registerLazySingleton(() => MilestoneApi());
  locator.registerLazySingleton(() => PortalApi());
  locator.registerLazySingleton(() => ProjectApi());
  locator.registerLazySingleton(() => SecureStorage());
  locator.registerLazySingleton(() => TaskApi());
  locator.registerLazySingleton(() => UserApi());
  locator.registerLazySingleton(() => DownloadApi());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => CommentsService());
  locator.registerLazySingleton(() => FilesService());
  locator.registerLazySingleton(() => GroupService());
  locator.registerLazySingleton(() => MilestoneService());
  locator.registerLazySingleton(() => PortalService());
  locator.registerLazySingleton(() => ProjectService());
  locator.registerLazySingleton(() => TaskItemService());
  locator.registerLazySingleton(() => TaskService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => DownloadService());

  Get.lazyPut(() => CommentsController(), fenix: true);
  // Get.lazyPut(() => FilesController(), fenix: true);
  Get.lazyPut(() => GroupsController(), fenix: true);
  Get.lazyPut(() => MilestonesController(), fenix: true);
  Get.lazyPut(() => NewTaskController(), fenix: true);
  Get.lazyPut(() => ProjectsController(), fenix: true);
  Get.lazyPut(() => TaskFilterController(), fenix: true);
  Get.lazyPut(() => TaskStatusesController(), fenix: true);
  Get.lazyPut(() => TasksController(), fenix: true);

  Get.lazyPut(() => TasksSortController(), fenix: true);
  Get.lazyPut(() => UserController(), fenix: true);
  Get.lazyPut(() => UsersController(), fenix: true);

  Get.lazyPut(() => UsersDataSource(), fenix: true);
  Get.lazyPut(() => GroupsDataSource(), fenix: true);
  Get.lazyPut(() => ProjectsSortController(), fenix: true);

  Get.lazyPut(() => ProjectTasksController(), fenix: true);
  Get.lazyPut(() => ProjectsFilterController(), fenix: true);
}
