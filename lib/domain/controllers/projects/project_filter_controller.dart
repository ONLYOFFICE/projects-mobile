import 'package:get/get.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class ProjectsFilterController extends BaseFilterController {
  final _api = locator<ProjectService>();

  final _sortController = Get.find<ProjectsSortController>();
  Function applyFiltersDelegate;

  String _teamMemberFilter = '';
  String _projectManagerFilter = '';
  String _otherFilter = '';
  String _statusFilter = '';

  String get projectManagerFilter => _projectManagerFilter;
  String get teamMemberFilter => _teamMemberFilter;
  String get otherFilter => _otherFilter;
  String get statusFilter => _statusFilter;

  var _selfId;

  bool get _hasFilters =>
      _projectManagerFilter.isNotEmpty ||
      _teamMemberFilter.isNotEmpty ||
      _otherFilter.isNotEmpty ||
      _statusFilter.isNotEmpty;

  RxMap<String, dynamic> projectManager = {'me': false, 'other': ''}.obs;
  RxMap<String, dynamic> teamMember = {'me': false, 'other': ''}.obs;

  RxMap<String, dynamic> other =
      {'followed': false, 'withTag': '', 'withoutTag': false}.obs;

  RxMap<String, dynamic> status =
      {'active': false, 'paused': false, 'closed': false}.obs;

  ProjectsFilterController() {
    filtersTitle = 'PROJECTS';
    suitableResultCount = (-1).obs;
  }

  Future<void> changeProjectManager(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _projectManagerFilter = '';
    if (filter == 'me') {
      projectManager['other'] = '';
      projectManager['me'] = !projectManager['me'];
      if (projectManager['me']) _projectManagerFilter = '&manager=$_selfId';
    }
    if (filter == 'other') {
      projectManager['me'] = false;
      if (newValue == null) {
        projectManager['other'] = '';
      } else {
        projectManager['other'] = newValue['displayName'];
        _projectManagerFilter = '&manager=${newValue["id"]}';
      }
    }
    getSuitableResultCount();
  }

  Future<void> changeTeamMember(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _teamMemberFilter = '';
    if (filter == 'me') {
      teamMember['other'] = '';
      teamMember['me'] = !teamMember['me'];
      if (teamMember['me']) _teamMemberFilter = '&participant=$_selfId';
    }
    if (filter == 'other') {
      teamMember['me'] = false;
      if (newValue == null) {
        teamMember['other'] = '';
      } else {
        teamMember['other'] = newValue['displayName'];
        _teamMemberFilter = '&participant=${newValue["id"]}';
      }
    }
    getSuitableResultCount();
  }

  void changeOther(String filter, [newValue = '']) async {
    _otherFilter = '';
    switch (filter) {
      case 'followed':
        other['followed'] = !other['followed'];
        other['withTag'] = '';
        other['withoutTag'] = false;

        if (other['followed']) _otherFilter = '&follow=true';
        break;
      case 'withTag':
        other['followed'] = false;
        other['withoutTag'] = false;
        if (newValue == null) {
          other['withTag'] = '';
        } else {
          other['withTag'] = newValue['title'];
          _otherFilter = '&tag=${newValue["id"]}';
        }
        break;
      case 'withoutTag':
        other['followed'] = false;
        other['withTag'] = '';
        other['withoutTag'] = !other['withoutTag'];
        if (other['withoutTag']) _otherFilter = '&tag=-1';
        break;
      default:
    }
    getSuitableResultCount();
  }

  void changeStatus(String filter, [newValue = '']) async {
    _statusFilter = '';
    switch (filter) {
      case 'active':
        status['active'] = !status['active'];
        status['paused'] = false;
        status['closed'] = false;

        if (status['active']) _statusFilter = '&status=open';
        break;
      case 'paused':
        status['active'] = false;
        status['paused'] = !status['paused'];
        status['closed'] = false;

        if (status['paused']) _statusFilter = '&status=paused';
        break;
      case 'closed':
        status['active'] = false;
        status['paused'] = false;
        status['closed'] = !status['closed'];

        if (status['closed']) _statusFilter = '&status=closed';
        break;
      default:
    }
    getSuitableResultCount();
  }

  @override
  void getSuitableResultCount() async {
    suitableResultCount.value = -1;
    hasFilters.value = _hasFilters;

    var result = await _api.getProjectsByParams(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectManagerFilter: projectManagerFilter,
      participantFilter: teamMemberFilter,
      otherFilter: otherFilter,
      statusFilter: statusFilter,
    );

    suitableResultCount.value = result.response.length;
  }

  @override
  void resetFilters() async {
    projectManager['me'] = false;
    projectManager['other'] = '';

    teamMember['me'] = false;
    teamMember['other'] = '';

    other['followed'] = false;
    other['withTag'] = '';
    other['withoutTag'] = false;

    status['active'] = false;
    status['paused'] = false;
    status['closed'] = false;

    suitableResultCount.value = -1;

    _projectManagerFilter = '';
    _teamMemberFilter = '';
    _otherFilter = '';
    _statusFilter = '';

    getSuitableResultCount();
  }

  @override
  void applyFilters() async {
    hasFilters.value = _hasFilters;
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }

  Future<void> setupPreset(String preset) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    switch (preset) {
      case 'myProjects':
        _statusFilter = '&status=open';
        _teamMemberFilter = '&participant=$_selfId';
        break;
      case 'myFollowedProjects':
        _statusFilter = '&status=open';
        _otherFilter = '&follow=true';
        break;
      case 'active':
        _statusFilter = '&status=open';
        break;
    }
  }
}
