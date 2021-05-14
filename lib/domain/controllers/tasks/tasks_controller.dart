import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/task_service.dart';

class TasksController extends BaseController {
  final _api = locator<TaskService>();

  PaginationController _paginationController;
  PaginationController get paginationController => _paginationController;

  var taskStatusesController = Get.find<TaskStatusesController>();
  final _sortController = Get.find<TasksSortController>();

  TaskFilterController _filterController;

  RxBool loaded = false.obs;

  // when snackbar appears
  RxBool fabIsRaised = false.obs;

  TasksController(TaskFilterController filterController,
      PaginationController paginationController) {
    taskStatusesController.getStatuses();

    _paginationController = paginationController;
    _filterController = filterController;

    _sortController.updateSortDelegate = () async {
      await loadTasks();
    };

    _filterController.applyFiltersDelegate = () {
      hasFilters.value = _filterController.hasFilters;
      loadTasks();
    };

    paginationController.loadDelegate = () async {
      await _getTasks();
    };
    paginationController.refreshDelegate = () async {
      await _getTasks(needToClear: true);
    };

    paginationController.pullDownEnabled = true;
  }

  @override
  String get screenName => 'Tasks';

  @override
  RxList get itemList => paginationController.data;

  Future loadTasks() async {
    loaded.value = false;
    paginationController.startIndex = 0;
    await _getTasks(needToClear: true);
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
      deadlineFilter: _filterController.deadlineFilter,
    );
    paginationController.total.value = result.total;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response);
  }

  Future raiseFAB() async {
    fabIsRaised.value = true;
    await Future.delayed(const Duration(milliseconds: 4600));
    fabIsRaised.value = false;
  }
}
