import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/task_service.dart';

class TasksController extends BaseController {
  final _api = locator<TaskService>();

  var paginationController =
      Get.put(PaginationController(), tag: 'TasksController');

  final _sortController = Get.find<TasksSortController>();
  final _filterController = Get.find<TaskFilterController>();

  RxBool loaded = false.obs;

  TasksController() {
    _sortController.updateSortDelegate = reloadTasks;

    _filterController.applyFiltersDelegate = () {
      hasFilters.value = _filterController.hasFilters;
      reloadTasks();
    };

    paginationController.loadDelegate = () {
      getTasks();
    };
    paginationController.refreshDelegate = reloadTasks;

    paginationController.pullDownEnabled = true;
  }

  @override
  String get screenName => 'Tasks';

  @override
  RxList get itemList => paginationController.data;

  Future reloadTasks() async {
    loaded.value = false;
    await _getTasks(needToClear: true);
    loaded.value = true;
  }

  Future getTasks() async {
    loaded.value = false;
    await _getTasks();
    loaded.value = true;
  }

  Future _getTasks({needToClear = false}) async {
    var result = await _api.getTasksByParams(
      startIndex: paginationController.startIndex,
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      responsibleFilter: _filterController.responsibleFilter,
      creatorFilter: _filterController.creatorFilter,
      projectFilter: _filterController.projectFilter,
      milestoneFilter: _filterController.milestoneFilter,
    );
    paginationController.total = result.total;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response);
  }
}
