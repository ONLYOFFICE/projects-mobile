import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class MilestonesFilterController extends BaseFilterController {
  final _api = locator<MilestoneService>();

  final _sortController = Get.find<MilestonesSortController>();
  Function applyFiltersDelegate;

  String _taskResponsibleFilter = '';
  String _milestoneResponsibleFilter = '';
  String _deadlineFilter = '';
  String _statusFilter = '';

  String get milestoneResponsibleFilter => _milestoneResponsibleFilter;
  String get taskResponsibleFilter => _taskResponsibleFilter;

  String get statusFilter => _statusFilter;
  String get deadlineFilter => _deadlineFilter;

  var _selfId;
  String _projectId;
  set projectId(String value) => _projectId = value;

  @override
  bool get hasFilters =>
      _milestoneResponsibleFilter.isNotEmpty ||
      _taskResponsibleFilter.isNotEmpty ||
      _deadlineFilter.isNotEmpty ||
      _statusFilter.isNotEmpty;

  RxMap<String, dynamic> milestoneResponsible = {'me': false, 'other': ''}.obs;
  RxMap<String, dynamic> taskResponsible = {'me': false, 'other': ''}.obs;
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
  RxMap<String, dynamic> status =
      {'active': false, 'paused': false, 'closed': false}.obs;

  MilestonesFilterController() {
    filtersTitle = 'MILESTONES';
    suitableResultCount = (-1).obs;
  }

  Future<void> changeResponsible(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _milestoneResponsibleFilter = '';
    if (filter == 'me') {
      milestoneResponsible['other'] = '';
      milestoneResponsible['me'] = !milestoneResponsible['me'];
      if (milestoneResponsible['me'])
        _milestoneResponsibleFilter = '&manager=$_selfId';
    }
    if (filter == 'other') {
      milestoneResponsible['me'] = false;
      if (newValue == null) {
        milestoneResponsible['other'] = '';
      } else {
        milestoneResponsible['other'] = newValue['displayName'];
        _milestoneResponsibleFilter = '&milestoneResponsible=${newValue["id"]}';
      }
    }
    getSuitableTasksCount();
  }

  Future<void> changeTasksResponsible(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _taskResponsibleFilter = '';
    if (filter == 'me') {
      taskResponsible['other'] = '';
      taskResponsible['me'] = !taskResponsible['me'];
      if (taskResponsible['me'])
        _taskResponsibleFilter = '&participant=$_selfId';
    }
    if (filter == 'other') {
      taskResponsible['me'] = false;
      if (newValue == null) {
        taskResponsible['other'] = '';
      } else {
        taskResponsible['other'] = newValue['displayName'];
        _taskResponsibleFilter = '&taskResponsible=${newValue["id"]}';
      }
    }

    getSuitableTasksCount();
  }

// deadlineStart=2021-05-05T16:12:19.852438&deadlineStop=2021-05-05T16:12:19.852438&projectid=397724
  Future<void> changeDeadline(String filter,
      {DateTime start, DateTime stop}) async {
    _deadlineFilter = '';
    final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.mmm');

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

    getSuitableTasksCount();
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
    getSuitableTasksCount();
  }

  void getSuitableTasksCount() async {
    suitableResultCount.value = -1;

    var result = await _api.milestonesByFilter(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectId: _projectId.toString(),
      milestoneResponsibleFilter: milestoneResponsibleFilter,
      taskResponsibleFilter: taskResponsibleFilter,
      statusFilter: statusFilter,
      deadlineFilter: deadlineFilter,
    );

    suitableResultCount.value = result.length;
  }

  @override
  void resetFilters() async {
    milestoneResponsible = {'me': false, 'other': ''}.obs;
    taskResponsible = {'me': false, 'other': ''}.obs;
    status = {'active': false, 'paused': false, 'closed': false}.obs;
    deadline = {
      'overdue': false,
      'today': false,
      'upcoming': false,
      'custom': {
        'selected': false,
        'startDate': DateTime.now(),
        'stopDate': DateTime.now()
      }
    }.obs;

    suitableResultCount.value = -1;

    _milestoneResponsibleFilter = '';
    _taskResponsibleFilter = '';
    _deadlineFilter = '';
    _statusFilter = '';

    applyFilters();
  }

  @override
  void applyFilters() async {
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }
}
