import 'package:get/get.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:projects/data/services/tasks_service.dart';

class TasksController extends BaseController {
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

  @override
  String get screenName => 'Tasks';

  @override
  RxList get itemList => tasks;

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
