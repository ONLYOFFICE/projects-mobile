import 'package:get/get.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:projects/data/services/task_service.dart';

class TasksController extends BaseController {
  final _api = locator<TaskService>();

  var tasks = <PortalTask>[].obs;

  var refreshController = RefreshController(initialRefresh: false);

//for shimmer and progress indicator
  RxBool loaded = false.obs;

  void onRefresh() async {
    await getTasks();
    refreshController.refreshCompleted();
  }

  Future getTasks({String params}) async {
    loaded.value = false;
    tasks.value = await _api.getTasks(params: params);
    loaded.value = true;
  }

  @override
  String get screenName => 'Tasks';

  @override
  RxList get itemList => tasks;
}
