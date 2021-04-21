import 'package:get/get.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class ProjectsFilterController extends BaseFilterController {
  final _api = locator<ProjectService>();

  final _sortController = Get.find<TasksSortController>();
  Function applyFiltersDelegate;

  // only accepted filters
  RxString acceptedFilters = ''.obs;

  String _teamMemberFilter = '';
  String _projectManagerFilter = '';
  String _otherFilter = '';
  String _statusFilter = '';

  @override
  var filtersTitle = 'PROJECTS';

  String get projectManagerFilter => _projectManagerFilter;
  String get teamMemberFilter => _teamMemberFilter;
  String get otherFilter => _otherFilter;
  String get statusFilter => _statusFilter;

  var _selfId;

  @override
  RxInt suitableTasksCount = (-1).obs;

  @override
  bool get hasFilters =>
      _projectManagerFilter.isNotEmpty ||
      _teamMemberFilter.isNotEmpty ||
      _otherFilter.isNotEmpty ||
      _statusFilter.isNotEmpty;

  RxMap<String, dynamic> projectManager = {'Me': false, 'Other': ''}.obs;
  RxMap<String, dynamic> teamMember = {'Me': false, 'Other': ''}.obs;

  RxMap<String, dynamic> other =
      {'Followed': false, 'With tag': '', 'Without tag': false}.obs;

  RxMap<String, dynamic> status =
      {'Active': false, 'Paused': false, 'Closed': false}.obs;

  Future<void> changeProjectManager(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _projectManagerFilter = '';
    if (filter == 'Me') {
      projectManager['Other'] = '';
      projectManager['Me'] = !projectManager['Me'];
      if (projectManager['Me']) _projectManagerFilter = '&manager=$_selfId';
    }
    if (filter == 'Other') {
      projectManager['Me'] = false;
      if (newValue == null) {
        projectManager['Other'] = '';
      } else {
        projectManager['Other'] = newValue['displayName'];
        _projectManagerFilter = '&manager=${newValue["id"]}';
      }
    }
    getSuitableTasksCount();
  }

  Future<void> changeTeamMember(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _teamMemberFilter = '';
    if (filter == 'Me') {
      teamMember['Other'] = '';
      teamMember['Me'] = !teamMember['Me'];
      if (teamMember['Me']) _teamMemberFilter = '&participant=$_selfId';
    }
    if (filter == 'Other') {
      teamMember['Me'] = false;
      if (newValue == null) {
        teamMember['Other'] = '';
      } else {
        teamMember['Other'] = newValue['displayName'];
        _teamMemberFilter = '&participant=${newValue["id"]}';
      }
    }
    getSuitableTasksCount();
  }

  void changeOther(String filter, [newValue = '']) async {
    _otherFilter = '';
    switch (filter) {
      case 'Followed':
        other['Followed'] = !other['Followed'];
        other['With tag'] = '';
        other['Without tag'] = false;

        if (other['Followed']) _otherFilter = '&follow=true';
        break;
      case 'With tag':
        other['Followed'] = false;
        other['Without tag'] = false;
        if (newValue == null) {
          other['With tag'] = '';
        } else {
          other['With tag'] = newValue['title'];
          _otherFilter = '&tag=${newValue["id"]}';
        }
        break;
      case 'Without tag':
        other['Followed'] = false;
        other['With tag'] = '';
        other['Without tag'] = !other['Without tag'];
        if (other['Without tag']) _otherFilter = '&tag=-1';
        break;
      default:
    }
    getSuitableTasksCount();
  }

  void changeStatus(String filter, [newValue = '']) async {
    _statusFilter = '';
    switch (filter) {
      case 'Active':
        status['Active'] = !status['Active'];
        status['Paused'] = false;
        status['Closed'] = false;

        if (status['Active']) _statusFilter = '&status=open';
        break;
      case 'Paused':
        status['Active'] = false;
        status['Paused'] = !status['Paused'];
        status['Closed'] = false;

        if (status['Paused']) _statusFilter = '&status=paused';
        break;
      case 'Closed':
        status['Active'] = false;
        status['Paused'] = false;
        status['Closed'] = !status['Closed'];

        if (status['Closed']) _statusFilter = '&status=closed';
        break;
      default:
    }
    getSuitableTasksCount();
  }

  void getSuitableTasksCount() async {
    suitableTasksCount.value = -1;

    var result = await _api.getProjectsByParams(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectManagerFilter: projectManagerFilter,
      participantFilter: teamMemberFilter,
      otherFilter: otherFilter,
      statusFilter: statusFilter,
    );

    suitableTasksCount.value = result.response.length;
  }

  @override
  void resetFilters() async {
    projectManager = {'Me': false, 'Other': ''}.obs;
    teamMember = {'Me': false, 'Other': ''}.obs;
    other = {'Followed': false, 'With tag': '', 'Without tag': false}.obs;
    status = {'Active': false, 'Paused': false, 'Closed': false}.obs;

    acceptedFilters.value = '';
    suitableTasksCount.value = -1;

    _projectManagerFilter = '';
    _teamMemberFilter = '';
    _otherFilter = '';
    _statusFilter = '';

    applyFilters();
  }

  @override
  void applyFilters() async {
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }
}
