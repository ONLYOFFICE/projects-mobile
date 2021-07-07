import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
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
  TasksSortController get sortController => _sortController;

  TaskFilterController _filterController;
  TaskFilterController get filterController => _filterController;

  RxBool loaded = false.obs;

  // when snackbar appears
  RxBool fabIsRaised = false.obs;

  var scrollController = ScrollController();
  var needToShowDivider = false.obs;

  TasksController(TaskFilterController filterController,
      PaginationController paginationController) {
    taskStatusesController.getStatuses();

    _paginationController = paginationController;
    _filterController = filterController;
    _sortController.updateSortDelegate = () async => await loadTasks();
    _filterController.applyFiltersDelegate = () async => loadTasks();
    paginationController.loadDelegate = () async => await _getTasks();
    paginationController.refreshDelegate =
        () async => await _getTasks(needToClear: true);
    paginationController.pullDownEnabled = true;

    scrollController.addListener(
        () => needToShowDivider.value = scrollController.offset > 2);
  }

  @override
  String get screenName => tr('tasks');

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
  void showSearch() => Get.toNamed('TasksSearchScreen');
}
