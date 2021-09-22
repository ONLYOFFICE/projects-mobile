import 'package:get/get.dart';
import 'package:projects/data/models/from_api/security_info.dart';
import 'package:projects/data/services/project_service.dart';
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

  TaskFilterController get filterController => _filterController;
  TasksSortController get sortController => _sortController;

  RxBool loaded = false.obs;

  var hasFilters = false.obs;

  int _projectId;

  String _selfId;
  final _projectService = locator<ProjectService>();
  final _userController = Get.find<UserController>();
  SecrityInfo _securityInfo;
  var fabIsVisible = false.obs;

  ProjectTasksController() {
    _sortController.updateSortDelegate = () async => await loadTasks();
    _filterController.applyFiltersDelegate = () async => loadTasks();
    paginationController.loadDelegate = () async => await _getTasks();
    paginationController.refreshDelegate =
        () async => await _getTasks(needToClear: true);
    paginationController.pullDownEnabled = true;
  }

  bool get canCreate =>
      _userController.user.isAdmin ||
      _userController.user.isOwner ||
      _securityInfo.canCreateTask;

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

  Future<void> setup(int projectId) async {
    _projectId = projectId;
    _filterController.projectId = _projectId.toString();

// ignore: unawaited_futures
    loadTasks();

    await _userController.getUserInfo();
    _selfId ??= await _userController.getUserId();
    _securityInfo ??= await _projectService.getProjectSecurityinfo();
    var team = await _projectService.getProjectTeam(projectId.toString());
    if (team.any((element) => element.id == _selfId))
      fabIsVisible.value = canCreate;
    else
      fabIsVisible.value = false;
  }
}
