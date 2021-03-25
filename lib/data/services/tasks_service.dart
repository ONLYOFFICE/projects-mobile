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
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class TasksService {

  final TasksApi _api = locator<TasksApi>();

  var portalTask = PortalTask().obs;

  Future getTaskByID({int id}) async {
    var task = await _api.getTaskByID(id: id);

    var success = task.response != null;

    if (success) {
      return task.response;
    } else {
      ErrorDialog.show(task.error);
      return null;
    }
  }


  Future getTasks() async {
    var task = await _api.getTasks();

    var success = task.response != null;

    if (success) {
      return task.response;
    } else {
      ErrorDialog.show(task.error);
      return null;
    }
  }


}

// class TasksService {

//   final TaskApi _api = locator<TaskApi>();

//   var portalTask = PortalTask().obs;


//   Future getTaskByID({int id}) async {
//     var task = await _api.getTaskByID(id: id);

//     print('TASK!!');
//     print(task);

//     var success = task.response != null;

//     if (success) {
//       return task.response;
//     } else {
//       ErrorDialog.show(task.error);
//       return null;
//     }
//   }
  
// }

// import 'dart:async';

// import 'package:projects/data/api/tasks_api.dart';
// import 'package:projects/data/models/from_api/project.dart';
// import 'package:projects/data/models/from_api/project_detailed.dart';
// import 'package:projects/data/models/from_api/status.dart';
// import 'package:projects/data/models/from_api/task.dart';
// import 'package:projects/domain/dialogs.dart';
// import 'package:projects/internal/locator.dart';

// class TaskService {

//   final TaskApi _api = locator<TaskApi>();

//   var 
  
// }

// class TasksService {

//   final TasksApi _api = locator<TasksApi>();

//   Future<List<Project>> getTasks() async {
//     var projects = await _api.getTasks();

//     var success = projects.response != null;

//     if (success) {
//       return projects.response;
//     } else {
//       ErrorDialog.show(projects.error);
//       return null;
//     }
//   }



//   Future<List<ProjectDetailed>> getProjectsByParams() async {
//     var projects = await _api.getProjectsByParams();

//     var success = projects.response != null;

//     if (success) {
//       return projects.response;
//     } else {
//       ErrorDialog.show(projects.error);
//       return null;
//     }
//   }

//   Future<List<Status>> getStatuses() async {
//     var projects = await _api.getStatuses();

//     var success = projects.response != null;

//     if (success) {
//       return projects.response;
//     } else {
//       ErrorDialog.show(projects.error);
//       return null;
//     }
//   }

//   Future<List<Status>> getProjectStatuses() async {
//     var projects = await _api.getStatuses();

//     var success = projects.response != null;

//     if (success) {
//       return projects.response;
//     } else {
//       ErrorDialog.show(projects.error);
//       return null;
//     }
//   }

//   Future<List<PortalTask>> getTasksByParams({String participant = ''}) async {
//     var projects = await _api.getTasksByFilter(participant: participant);

//     var success = projects.response != null;

//     if (success) {
//       return projects.response;
//     } else {
//       ErrorDialog.show(projects.error);
//       return null;
//     }
//   }
// }



//   // Future<List<PortalTask>> getTaskById(int id) async {
//   //   var task = await _api.getTaskById(id);

//   //   var success = task.response != null;

//   //   if (success) {
//   //     return task.response;
//   //   } else {
//   //     ErrorDialog.show(task.error);
//   //     return null;
//   //   }
//   // }
// //   final _api2 = locator<TasksService>();

// //   Future getTask({int id}) async {
// //     var task = await _api2.getTaskById(id);
// //     print(task);
// // // https://nct.onlyoffice.com/api/2.0/project/task/filter.json
// // // ?sortBy=deadline
// // // &sortOrder=ascending
// // // &participant=0f6e1c96-a452-4d1d-b064-0fd015625e4d
// // // &Count=25
// // // &StartIndex=0
// // // &simple=true
// // // &__=651640
// //     // tasks.clear();
// //     // items.forEach(
// //     //   (element) {
// //     //     var responsible =
// //     //         CustomList.firstOrNull(element.responsibles) ?? element.createdBy;
// //     //     tasks.add(Item(
// //     //       id: element.id,
// //     //       title: element.title,
// //     //       status: element.status,
// //     //       responsible: responsible,
// //     //       date: element.creationDate(),
// //     //       subCount: 0,
// //     //       isImportant: false,
// //     //     ));
// //     //   },
// //     // );
// //     update();
// //   }
