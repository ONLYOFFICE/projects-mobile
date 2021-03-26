import 'package:get/get.dart';
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class DetailedTaskController extends GetxController {
  
  final _api = locator<DetailedTaskService>();

  var loaded = false.obs;

  var task = PortalTask();

  Future getTask(int id) async {

    loaded.value = false;
    task = await _api.getTaskByID(id: id);
    loaded.value = true;

  }

}

class DetailedTaskService {

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
  
}

// // class TasksController extends GetxController {
// //   final _api = locator<ProjectService>();
// //   // final _api2 = locator<TasksService>();
// //   UserController userController = Get.find();

// //   List<Status> statuses;

// //   var tasks = [].obs;

// //   RefreshController refreshController = RefreshController(initialRefresh: true);

// //   void onRefresh() async {
// //     await getTasks();
// //     refreshController.refreshCompleted();
// //   }

// //   void onLoading() async {
// //     await getTasks();
// //     refreshController.loadComplete();
// //   }

// //   Future getTasks() async {
// //     var items = await _api.getTasksByParams(
// //         participant: await userController.getUserId());
// // // https://nct.onlyoffice.com/api/2.0/project/task/filter.json
// // // ?sortBy=deadline
// // // &sortOrder=ascending
// // // &participant=0f6e1c96-a452-4d1d-b064-0fd015625e4d
// // // &Count=25
// // // &StartIndex=0
// // // &simple=true
// // // &__=651640
// //     tasks.clear();
// //     items.forEach(
// //       (element) {
// //         var responsible =
// //             CustomList.firstOrNull(element.responsibles) ?? element.createdBy;
// //         tasks.add(Item(
// //           id: element.id,
// //           title: element.title,
// //           status: element.status,
// //           responsible: responsible,
// //           date: element.creationDate(),
// //           subCount: 0,
// //           isImportant: false,
// //         ));
// //       },
// //     );
// //     update();
// //   }

// //   Future getTask({int id}) async {
// //     var items = await _api.getTasksByParams(
// //         participant: await userController.getUserId());
// // // https://nct.onlyoffice.com/api/2.0/project/task/filter.json
// // // ?sortBy=deadline
// // // &sortOrder=ascending
// // // &participant=0f6e1c96-a452-4d1d-b064-0fd015625e4d
// // // &Count=25
// // // &StartIndex=0
// // // &simple=true
// // // &__=651640
// //     tasks.clear();
// //     items.forEach(
// //       (element) {
// //         var responsible =
// //             CustomList.firstOrNull(element.responsibles) ?? element.createdBy;
// //         tasks.add(Item(
// //           id: element.id,
// //           title: element.title,
// //           status: element.status,
// //           responsible: responsible,
// //           date: element.creationDate(),
// //           subCount: 0,
// //           isImportant: false,
// //         ));
// //       },
// //     );
// //     update();
// //   }
// // }
