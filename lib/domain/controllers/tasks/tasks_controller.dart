import 'package:get/get.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/domain/controllers/tasks/sort_controller.dart';
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
    var sortController = Get.find<TasksSortController>();
    loaded.value = false;
    tasks.value = await _api.getTasks();
    await sortController.sortTasks();
    loaded.value = true;
  }

  @override
  String get screenName => 'Tasks';

  @override
  RxList get itemList => tasks;
}
