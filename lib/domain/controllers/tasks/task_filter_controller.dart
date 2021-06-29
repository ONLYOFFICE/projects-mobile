import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projects/data/services/task_service.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class TaskFilterController extends BaseFilterController {
  final _api = locator<TaskService>();
  final _sortController = Get.find<TasksSortController>();

  final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.mmm');

  Function applyFiltersDelegate;

  RxString acceptedFilters = ''.obs;

  String _responsibleFilter = '';
  String _creatorFilter = '';
  String _projectFilter = '';
  String _milestoneFilter = '';
  String _deadlineFilter = '';

  String get responsibleFilter => _responsibleFilter;
  String get creatorFilter => _creatorFilter;
  String get projectFilter => _projectFilter;
  String get milestoneFilter => _milestoneFilter;
  String get deadlineFilter => _deadlineFilter;

  var _selfId;
  String _projectId;

  bool get _hasFilters =>
      _responsibleFilter.isNotEmpty ||
      _creatorFilter.isNotEmpty ||
      _projectFilter.isNotEmpty ||
      _deadlineFilter.isNotEmpty ||
      _milestoneFilter.isNotEmpty;

  RxMap<String, dynamic> responsible =
      {'me': false, 'other': '', 'groups': '', 'no': false}.obs;

  RxMap<String, dynamic> creator = {'me': false, 'other': ''}.obs;

  RxMap<String, dynamic> project =
      {'my': false, 'other': '', 'withTag': '', 'withoutTag': false}.obs;

  RxMap<String, dynamic> milestone =
      {'my': false, 'no': false, 'other': ''}.obs;

  RxMap<String, dynamic> deadline = {
    'overdue': false,
    'today': false,
    'upcoming': false,
    'custom': {
      'selected': false,
      'startDate': DateTime.now(),
      'stopDate': DateTime.now()
    }
  }.obs;

  @override
  String get filtersTitle =>
      plural('tasksFilterConfirm', suitableResultCount.value);

  TaskFilterController() {
    suitableResultCount = (-1).obs;
  }

  set projectId(String value) => _projectId = value;

  void changeResponsible(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _responsibleFilter = '';

    switch (filter) {
      case 'me':
        responsible['other'] = '';
        responsible['groups'] = '';
        responsible['no'] = false;
        responsible['me'] = !responsible['me'];
        if (responsible['me']) _responsibleFilter = '&participant=$_selfId';
        break;
      case 'other':
        responsible['me'] = false;
        responsible['groups'] = '';
        responsible['no'] = false;
        if (newValue == null) {
          responsible['other'] = '';
        } else {
          responsible['other'] = newValue['displayName'];
          _responsibleFilter = '&participant=${newValue["id"]}';
        }
        break;
      case 'groups':
        responsible['me'] = false;
        responsible['other'] = '';
        responsible['no'] = false;
        if (newValue == null) {
          responsible['groups'] = '';
        } else {
          responsible['groups'] = newValue['name'];
          _responsibleFilter = '&departament=${newValue["id"]}';
        }
        break;
      case 'no':
        responsible['me'] = false;
        responsible['other'] = '';
        responsible['groups'] = '';
        responsible['no'] = !responsible['no'];
        if (responsible['no']) {
          _responsibleFilter =
              '&participant=00000000-0000-0000-0000-000000000000';
        }
        break;
      default:
    }
    getSuitableResultCount();
  }

  Future<void> changeCreator(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _creatorFilter = '';
    if (filter == 'me') {
      creator['other'] = '';
      creator['me'] = !creator['me'];
      if (creator['me']) _creatorFilter = '&creator=$_selfId';
    }
    if (filter == 'other') {
      creator['me'] = false;
      if (newValue == null) {
        creator['other'] = '';
      } else {
        creator['other'] = newValue['displayName'];
        _creatorFilter = '&creator=${newValue["id"]}';
      }
    }
    getSuitableResultCount();
  }

  void changeProject(String filter, [newValue = '']) async {
    _projectFilter = '';
    switch (filter) {
      case 'my':
        project['other'] = '';
        project['withTag'] = '';
        project['withoutTag'] = false;
        project['my'] = !project['my'];
        if (project['my']) _projectFilter = '&myprojects=true';
        break;
      case 'other':
        project['my'] = false;
        project['withTag'] = '';
        project['withoutTag'] = false;
        if (newValue == null) {
          project['other'] = '';
        } else {
          project['other'] = newValue['title'];
          _projectFilter = '&projectId=${newValue["id"]}';
        }
        break;
      case 'withTag':
        project['my'] = false;
        project['other'] = '';
        project['withoutTag'] = false;
        if (newValue == null) {
          project['withTag'] = '';
        } else {
          project['withTag'] = newValue['title'];
          _projectFilter = '&tag=${newValue["id"]}';
        }
        break;
      case 'withoutTag':
        project['my'] = false;
        project['other'] = '';
        project['withTag'] = '';
        project['withoutTag'] = !project['withoutTag'];
        if (project['withoutTag']) _projectFilter = '&tag=-1';
        break;
      default:
    }
    getSuitableResultCount();
  }

  void changeMilestone(String filter, [newValue]) {
    _milestoneFilter = '';
    switch (filter) {
      case 'my':
        milestone['no'] = false;
        milestone['other'] = '';
        milestone['my'] = !milestone['my'];
        if (milestone['my']) _milestoneFilter = '&mymilestones=true';
        break;
      case 'no':
        milestone['my'] = false;
        milestone['other'] = '';
        milestone['no'] = !milestone['no'];
        if (milestone['no']) _milestoneFilter = '&nomilestone=true';
        break;
      case 'other':
        milestone['my'] = false;
        milestone['no'] = false;
        if (newValue == null) {
          milestone['other'] = '';
        } else {
          milestone['other'] = newValue['title'];
          _milestoneFilter = '&milestone=${newValue["id"]}';
        }
        break;
      default:
    }
    getSuitableResultCount();
  }

  Future<void> changeDeadline(String filter,
      {DateTime start, DateTime stop}) async {
    _deadlineFilter = '';

    if (filter == 'overdue') {
      deadline['upcoming'] = false;
      deadline['today'] = false;
      deadline['custom']['selected'] = false;
      deadline['overdue'] = !deadline['overdue'];
      var dueDate = formatter.format(DateTime.now());
      if (deadline['overdue']) _deadlineFilter = '&deadlineStop=$dueDate';
    }
    if (filter == 'today') {
      deadline['overdue'] = false;
      deadline['upcoming'] = false;
      deadline['custom']['selected'] = false;
      deadline['today'] = !deadline['today'];
      var dueDate = formatter.format(DateTime.now());
      if (deadline['today'])
        _deadlineFilter = '&deadlineStart=$dueDate&deadlineStop=$dueDate';
    }
    if (filter == 'upcoming') {
      deadline['overdue'] = false;
      deadline['today'] = false;
      deadline['custom']['selected'] = false;
      deadline['upcoming'] = !deadline['upcoming'];
      var startDate = formatter.format(DateTime.now());
      var stopDate =
          formatter.format(DateTime.now().add(const Duration(days: 7)));
      if (deadline['upcoming'])
        _deadlineFilter = '&deadlineStart=$startDate&deadlineStop=$stopDate';
    }
    if (filter == 'custom') {
      deadline['overdue'] = false;
      deadline['today'] = false;
      deadline['upcoming'] = false;
      deadline['custom']['selected'] = !deadline['custom']['selected'];
      deadline['custom']['startDate'] = start;
      deadline['custom']['stopDate'] = stop;
      var startDate = formatter.format(start);
      var stopDate = formatter.format(stop);
      if (deadline['custom']['selected'])
        _deadlineFilter = '&deadlineStart=$startDate&deadlineStop=$stopDate';
    }

    getSuitableResultCount();
  }

  @override
  void getSuitableResultCount() async {
    suitableResultCount.value = -1;
    hasFilters.value = _hasFilters;

    var result = await _api.getTasksByParams(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      responsibleFilter: responsibleFilter,
      creatorFilter: creatorFilter,
      projectFilter: projectFilter,
      milestoneFilter: milestoneFilter,
      deadlineFilter: deadlineFilter,
      projectId: _projectId,
    );

    suitableResultCount.value = result.response.length;
  }

  @override
  void resetFilters() async {
    responsible['me'] = false;
    responsible['other'] = '';
    responsible['groups'] = '';
    responsible['no'] = false;

    creator['me'] = false;
    creator['other'] = '';

    project['my'] = false;
    project['other'] = '';
    project['withTag'] = '';
    project['withoutTag'] = false;

    milestone['my'] = false;
    milestone['no'] = false;
    milestone['other'] = '';

    deadline['overdue'] = false;
    deadline['today'] = false;
    deadline['upcoming'] = false;
    deadline['custom'] = {
      'selected': false,
      'startDate': DateTime.now(),
      'stopDate': DateTime.now()
    };

    acceptedFilters.value = '';
    suitableResultCount.value = -1;

    _responsibleFilter = '';
    _creatorFilter = '';
    _projectFilter = '';
    _milestoneFilter = '';
    _deadlineFilter = '';

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
      case 'myTasks':
        _responsibleFilter = '&participant=$_selfId';

        break;
      case 'upcomming':
        var startDate = formatter.format(DateTime.now());
        var stopDate =
            formatter.format(DateTime.now().add(const Duration(days: 7)));

        _deadlineFilter = '&deadlineStart=$startDate&deadlineStop=$stopDate';
        break;
    }
  }
}
