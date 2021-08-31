import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/internal/utils/debug_print.dart';

class ProjectsFilterController extends BaseFilterController {
  final _api = locator<ProjectService>();
  final _storage = locator<Storage>();

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

  RxMap projectManager;
  RxMap teamMember;

  RxMap other;

  RxMap status;

  @override
  String get filtersTitle =>
      plural('projectsFilterConfirm', suitableResultCount.value);

  ProjectsFilterController() {
    suitableResultCount = (-1).obs;
  }

  @override
  void onInit() async {
    await loadFilters();
    super.onInit();
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

  Future<void> changeOther(String filter, [newValue = '']) async {
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
    await saveFilters();
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }

  Future<void> setupPreset(PresetProjectFilters preset) async {
    _selfId ??= await Get.find<UserController>().getUserId();

    if (preset == PresetProjectFilters.myProjects) {
      await _getMyProjects();
    } else if (preset == PresetProjectFilters.myFollowedProjects) {
      _statusFilter = '&status=open';
      _otherFilter = '&follow=true';
    } else if (preset == PresetProjectFilters.active) {
      _statusFilter = '&status=open';
    } else if (preset == PresetProjectFilters.saved) {
      await _getSavedFilters();
    }
    hasFilters.value = _hasFilters;
  }

  @override
  Future<void> saveFilters() async {
    await _storage.write(
      'projectFilters',
      {
        'projectManager': {
          'buttons': projectManager,
          'value': _projectManagerFilter
        },
        'teamMember': {'buttons': teamMember, 'value': _teamMemberFilter},
        'other': {'buttons': other, 'value': _otherFilter},
        'status': {'buttons': status, 'value': _statusFilter},
        'hasFilters': _hasFilters,
      },
    );
  }

  @override
  Future<void> loadFilters() async {
    projectManager = {'me': false, 'other': ''}.obs;
    teamMember = {'me': true, 'other': ''}.obs;
    other = {'followed': false, 'withTag': '', 'withoutTag': false}.obs;
    status = {'active': true, 'paused': false, 'closed': false}.obs;
  }

  Future<void> _getMyProjects() async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _statusFilter = '&status=open';
    _teamMemberFilter = '&participant=$_selfId';
  }

  Future<void> _getSavedFilters() async {
    var savedFilters = await _storage.read('projectFilters');

    if (savedFilters != null) {
      try {
        projectManager =
            Map.from(savedFilters['projectManager']['buttons']).obs;
        _projectManagerFilter = savedFilters['projectManager']['value'];

        teamMember = Map.from(savedFilters['teamMember']['buttons']).obs;
        _teamMemberFilter = savedFilters['teamMember']['value'];

        other = Map.from(savedFilters['other']['buttons']).obs;
        _otherFilter = savedFilters['other']['value'];

        status = Map.from(savedFilters['status']['buttons']).obs;
        _statusFilter = savedFilters['status']['value'];

        hasFilters.value = savedFilters['hasFilters'];
      } catch (e) {
        printWarning('Projects filter loading error: $e');
        await loadFilters();
      }
    } else {
      await _getMyProjects();
    }
  }
}

enum PresetProjectFilters { active, myProjects, myFollowedProjects, saved }
