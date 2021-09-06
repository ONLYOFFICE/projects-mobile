import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/task/task_service.dart';
import 'package:projects/presentation/views/tasks/tasks_search_screen.dart';

class TasksController extends BaseController {
  final _api = locator<TaskService>();

  PaginationController _paginationController;
  PaginationController get paginationController => _paginationController;

  var taskStatusesController = Get.find<TaskStatusesController>();

  final _sortController = Get.find<TasksSortController>();
  TasksSortController get sortController => _sortController;

  TaskFilterController _filterController;
  TaskFilterController get filterController => _filterController;

  RxBool loaded = false.obs;

  // when snackbar appears
  RxBool fabIsRaised = false.obs;

  TasksController(TaskFilterController filterController,
      PaginationController paginationController) {
    screenName = tr('tasks');
    taskStatusesController.getStatuses();
    _paginationController = paginationController;
    expandedCardView.value = true;
    _filterController = filterController;
    _filterController.applyFiltersDelegate = () async => loadTasks();
    _sortController.updateSortDelegate = () async => await loadTasks();
    paginationController.loadDelegate = () async => await _getTasks();
    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;
  }

  @override
  RxList get itemList => paginationController.data;

  Future<void> refreshData() async {
    loaded.value = false;
    await _getTasks(needToClear: true);
    loaded.value = true;
  }

  Future loadTasks({PresetTaskFilters preset}) async {
    loaded.value = false;
    paginationController.startIndex = 0;

    if (preset != null) {
      await _filterController
          .setupPreset(preset)
          .then((value) => _getTasks(needToClear: true));
    } else {
      await _getTasks(needToClear: true);
    }

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
      statusFilter: _filterController.statusFilter,
      deadlineFilter: _filterController.deadlineFilter,
      // query: 'задача',
    );
    paginationController.total.value = result.total;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response);
    expandedCardView.value = paginationController.data.isNotEmpty;
  }

  Future raiseFAB() async {
    fabIsRaised.value = true;
    await Future.delayed(const Duration(milliseconds: 4600));
    fabIsRaised.value = false;
  }

  @override
  void showSearch() =>
      Get.find<NavigationController>().to(const TasksSearchScreen());
}
