import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/task_service.dart';

class ProjectTasksController extends GetxController {
  final _api = locator<TaskService>();

  final paginationController =
      Get.put(PaginationController(), tag: 'ProjectTasksController');

  final _sortController = Get.find<TasksSortController>();
  final _filterController = Get.find<TaskFilterController>();
  TaskFilterController get filterController => _filterController;

  RxBool loaded = false.obs;

  var hasFilters = false.obs;

  int _projectId;

  ProjectTasksController() {
    _sortController.updateSortDelegate = () async => await loadTasks();
    _filterController.applyFiltersDelegate = () async => loadTasks();
    paginationController.loadDelegate = () async => await _getTasks();
    paginationController.refreshDelegate =
        () async => await _getTasks(needToClear: true);
    paginationController.pullDownEnabled = true;
  }

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
        projectId: _projectId.toString());
    paginationController.total.value = result.total;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response);
  }

  void setup(int projectId) {
    _projectId = projectId;
    _filterController.projectId = _projectId.toString();
    loadTasks();
  }
}
