import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class MilestonesFilterController extends BaseFilterController {
  final _api = locator<MilestoneService>();
  final _storage = locator<Storage>();

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

  bool get _hasFilters =>
      _milestoneResponsibleFilter.isNotEmpty ||
      _taskResponsibleFilter.isNotEmpty ||
      _deadlineFilter.isNotEmpty ||
      _statusFilter.isNotEmpty;

  RxMap milestoneResponsible;
  RxMap taskResponsible;
  RxMap deadline;
  RxMap status;

  @override
  Future<void> restoreFilters() async => await _getSavedFilters();

  @override
  String get filtersTitle =>
      plural('milestonesFilterConfirm', suitableResultCount.value);

  MilestonesFilterController() {
    suitableResultCount = (-1).obs;
  }

  @override
  void onInit() async {
    await loadFilters();
    super.onInit();
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
    getSuitableResultCount();
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

    getSuitableResultCount();
  }

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
    milestoneResponsible['me'] = false;
    milestoneResponsible['other'] = '';

    taskResponsible['me'] = false;
    taskResponsible['other'] = '';

    status['active'] = false;
    status['paused'] = false;
    status['closed'] = false;

    deadline['overdue'] = false;
    deadline['today'] = false;
    deadline['upcoming'] = false;
    deadline['custom'] = {
      'selected': false,
      'startDate': DateTime.now(),
      'stopDate': DateTime.now()
    };

    suitableResultCount.value = -1;

    _milestoneResponsibleFilter = '';
    _taskResponsibleFilter = '';
    _deadlineFilter = '';
    _statusFilter = '';

    getSuitableResultCount();
  }

  @override
  void applyFilters() async {
    hasFilters.value = _hasFilters;
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }

  // UNUSED
  @override
  Future<void> saveFilters() async {
    var d = Map.from(deadline);

    var startDate = deadline['custom']['startDate'].toIso8601String();
    var stopDate = deadline['custom']['stopDate'].toIso8601String();

    d['custom'] = {
      'selected': deadline['custom']['selected'],
      'startDate': startDate,
      'stopDate': stopDate,
    };

    await _storage.write(
      'milestonesFilter',
      {
        'milestoneResponsible': {
          'buttons': milestoneResponsible,
          'value': _milestoneResponsibleFilter
        },
        'taskResponsible': {
          'buttons': taskResponsible,
          'value': _taskResponsibleFilter
        },
        'status': {'buttons': status, 'value': _statusFilter},
        'deadline': {'buttons': d, 'value': _deadlineFilter},
        'hasFilters': _hasFilters,
      },
    );
  }

  @override
  Future<void> loadFilters() async {
    milestoneResponsible = {'me': false, 'other': ''}.obs;
    taskResponsible = {'me': false, 'other': ''}.obs;
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
    status = {'active': false, 'paused': false, 'closed': false}.obs;
  }

  // UNUSED
  // ignore: unused_element
  Future<void> _getSavedFilters() async {
    var savedFilters =
        await _storage.read('milestoneFilters', returnCopy: true);

    if (savedFilters != null) {
      try {
        milestoneResponsible =
            Map.from(savedFilters['milestoneResponsible']['buttons']).obs;
        _milestoneResponsibleFilter =
            savedFilters['milestoneResponsible']['value'];

        taskResponsible =
            Map.from(savedFilters['taskResponsible']['buttons']).obs;
        _taskResponsibleFilter = savedFilters['taskResponsible']['value'];

        status = Map.from(savedFilters['status']['buttons']).obs;
        _statusFilter = savedFilters['status']['value'];

        Map d = savedFilters['deadline']['buttons'];
        d['custom'] = {
          'selected': d['custom']['selected'],
          'startDate': DateTime.parse(d['custom']['startDate']),
          'stopDate': DateTime.parse(d['custom']['stopDate']),
        };
        deadline = d.obs;
        _deadlineFilter = savedFilters['deadline']['value'];

        hasFilters.value = savedFilters['hasFilters'];
      } catch (e) {
        print(e);
        await loadFilters();
      }
    } else {
      await loadFilters();
    }
  }
}
