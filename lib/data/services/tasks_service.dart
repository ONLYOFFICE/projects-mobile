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
