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
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:projects/data/services/tasks_service.dart';

class TasksController extends GetxController {
  
  final _api = locator<TasksService>();

  var tasks = <PortalTask>[].obs;

  var refreshController = RefreshController(initialRefresh: false);

//for shimmer and progress indicator 
  RxBool loaded = false.obs;

  void onRefresh() async {
    await getTasks();
    refreshController.refreshCompleted();
  }


  Future getTasks() async {

    loaded.value = false;

    tasks.clear();
    tasks.addAll(await _api.getTasks());
    loaded.value = true;

  }

//   Future getTasks() async {
//     var items = await _api.getTasksByParams(
//         participant: await userController.getUserId());
// // https://nct.onlyoffice.com/api/2.0/project/task/filter.json
// // ?sortBy=deadline
// // &sortOrder=ascending
// // &participant=0f6e1c96-a452-4d1d-b064-0fd015625e4d
// // &Count=25
// // &StartIndex=0
// // &simple=true
// // &__=651640
//     tasks.clear();
//     items.forEach(
//       (element) {
//         var responsible =
//             CustomList.firstOrNull(element.responsibles) ?? element.createdBy;
//         tasks.add(Item(
//           id: element.id,
//           title: element.title,
//           status: element.status,
//           responsible: responsible,
//           date: element.creationDate(),
//           subCount: 0,
//           isImportant: false,
//         ));
//       },
//     );
//     update();
//   }





}

// import 'package:get/get.dart';

// import 'package:projects/data/models/from_api/status.dart';
// import 'package:projects/data/models/item.dart';

// import 'package:projects/data/services/project_service.dart';
// import 'package:projects/data/services/task_service.dart';
// import 'package:projects/domain/controllers/user_controller.dart';
// import 'package:projects/internal/locator.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// import 'package:projects/internal/extentions.dart';

// class TasksController extends GetxController {
//   final _api = locator<ProjectService>();
//   // final _api2 = locator<TasksService>();
//   UserController userController = Get.find();

//   List<Status> statuses;

//   var tasks = [].obs;

//   RefreshController refreshController = RefreshController(initialRefresh: true);

//   void onRefresh() async {
//     await getTasks();
//     refreshController.refreshCompleted();
//   }

//   void onLoading() async {
//     await getTasks();
//     refreshController.loadComplete();
//   }

//   Future getTasks() async {
//     var items = await _api.getTasksByParams(
//         participant: await userController.getUserId());
// // https://nct.onlyoffice.com/api/2.0/project/task/filter.json
// // ?sortBy=deadline
// // &sortOrder=ascending
// // &participant=0f6e1c96-a452-4d1d-b064-0fd015625e4d
// // &Count=25
// // &StartIndex=0
// // &simple=true
// // &__=651640
//     tasks.clear();
//     items.forEach(
//       (element) {
//         var responsible =
//             CustomList.firstOrNull(element.responsibles) ?? element.createdBy;
//         tasks.add(Item(
//           id: element.id,
//           title: element.title,
//           status: element.status,
//           responsible: responsible,
//           date: element.creationDate(),
//           subCount: 0,
//           isImportant: false,
//         ));
//       },
//     );
//     update();
//   }

//   Future getTask({int id}) async {
//     var items = await _api.getTasksByParams(
//         participant: await userController.getUserId());
// // https://nct.onlyoffice.com/api/2.0/project/task/filter.json
// // ?sortBy=deadline
// // &sortOrder=ascending
// // &participant=0f6e1c96-a452-4d1d-b064-0fd015625e4d
// // &Count=25
// // &StartIndex=0
// // &simple=true
// // &__=651640
//     tasks.clear();
//     items.forEach(
//       (element) {
//         var responsible =
//             CustomList.firstOrNull(element.responsibles) ?? element.createdBy;
//         tasks.add(Item(
//           id: element.id,
//           title: element.title,
//           status: element.status,
//           responsible: responsible,
//           date: element.creationDate(),
//           subCount: 0,
//           isImportant: false,
//         ));
//       },
//     );
//     update();
//   }
// }
