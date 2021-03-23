import 'package:get/get.dart';

import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/item.dart';

import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:projects/internal/extentions.dart';

class TasksController extends GetxController {
  var _api = locator<ProjectService>();
  UserController userController = Get.find();

  List<Status> statuses;

  var tasks = [].obs;

  RefreshController refreshController = RefreshController(initialRefresh: true);

  void onRefresh() async {
    await getProjects();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    await getProjects();
    refreshController.loadComplete();
  }

  Future getProjects() async {
    var items = await _api.getTasksByParams(
        participant: await userController.getUserId());
// https://nct.onlyoffice.com/api/2.0/project/task/filter.json
// ?sortBy=deadline
// &sortOrder=ascending
// &participant=0f6e1c96-a452-4d1d-b064-0fd015625e4d
// &Count=25
// &StartIndex=0
// &simple=true
// &__=651640
    tasks.clear();
    items.forEach(
      (element) {
        var responsible =
            CustomList.firstOrNull(element.responsibles) ?? element.createdBy;
        tasks.add(new Item(
          id: element.id,
          title: element.title,
          status: element.status,
          responsible: responsible,
          date: element.creationDate(),
          subCount: 0,
          isImportant: false,
        ));
      },
    );
    update();
  }
}
