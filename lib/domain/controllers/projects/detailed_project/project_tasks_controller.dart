import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/task/task_service.dart';

class ProjectTasksController extends GetxController {
  final _api = locator<TaskService>();

  final paginationController =
      Get.put(PaginationController(), tag: 'ProjectTasksController');

  final _sortController =
      Get.put(TasksSortController(), tag: 'ProjectTasksController');

  final _filterController =
      Get.put(TaskFilterController(), tag: 'ProjectTasksController');

  ProjectDetailed _projectDetailed;

  TaskFilterController get filterController => _filterController;
  TasksSortController get sortController => _sortController;

  RxBool loaded = false.obs;

  var hasFilters = false.obs;

  int _projectId;

  String _selfId;
  final _userController = Get.find<UserController>();

  var fabIsVisible = false.obs;

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
        deadlineFilter: _filterController.deadlineFilter,
        projectId: _projectId.toString());
    paginationController.total.value = result.total;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response);
  }

  Future<void> setup(ProjectDetailed projectDetailed) async {
    loaded.value = false;
    _projectDetailed = projectDetailed;
    _projectId = projectDetailed.id;
    _filterController.projectId = _projectId.toString();

// ignore: unawaited_futures
    loadTasks();

    await _userController.getUserInfo();
    _selfId ??= await _userController.getUserId();

    fabIsVisible.value = _canCreate();
  }

  bool _canCreate() => _projectDetailed.security['canCreateTask'];
}
