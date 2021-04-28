import 'package:get/get.dart';
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
  // String _otherFilter = '';
  String _statusFilter = '';

  String get milestoneResponsibleFilter => _milestoneResponsibleFilter;
  String get taskResponsibleFilter => _taskResponsibleFilter;
  // String get otherFilter => _otherFilter;
  String get statusFilter => _statusFilter;

  var _selfId;
  String _projectId;
  set projectId(String value) => _projectId = value;

  @override
  bool get hasFilters =>
      _milestoneResponsibleFilter.isNotEmpty ||
      _taskResponsibleFilter.isNotEmpty ||
      // _otherFilter.isNotEmpty ||
      _statusFilter.isNotEmpty;

// &deadlineStart=2021-04-28T00%3A00%3A00
// &deadlineStop=2021-05-05T00%3A00%3A00

  RxMap<String, dynamic> milestoneResponsible = {'me': false, 'other': ''}.obs;
  RxMap<String, dynamic> taskResponsible = {'me': false, 'other': ''}.obs;

  // RxMap<String, dynamic> other =
  //     {'followed': false, 'withTag': '', 'withoutTag': false}.obs;

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

  // void changeOther(String filter, [newValue = '']) async {
  //   _otherFilter = '';
  //   switch (filter) {
  //     case 'followed':
  //       other['followed'] = !other['followed'];
  //       other['withTag'] = '';
  //       other['withoutTag'] = false;

  //       if (other['followed']) _otherFilter = '&follow=true';
  //       break;
  //     case 'withTag':
  //       other['followed'] = false;
  //       other['withoutTag'] = false;
  //       if (newValue == null) {
  //         other['withTag'] = '';
  //       } else {
  //         other['withTag'] = newValue['title'];
  //         _otherFilter = '&tag=${newValue["id"]}';
  //       }
  //       break;
  //     case 'withoutTag':
  //       other['followed'] = false;
  //       other['withTag'] = '';
  //       other['withoutTag'] = !other['withoutTag'];
  //       if (other['withoutTag']) _otherFilter = '&tag=-1';
  //       break;
  //     default:
  //   }
  //   getSuitableTasksCount();
  // }

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
    );

    suitableResultCount.value = result.length;
  }

  @override
  void resetFilters() async {
    milestoneResponsible = {'me': false, 'other': ''}.obs;
    taskResponsible = {'me': false, 'other': ''}.obs;

    // other = {'followed': false, 'withTag': '', 'withoutTag': false}.obs;
    status = {'active': false, 'paused': false, 'closed': false}.obs;

    suitableResultCount.value = -1;

    _milestoneResponsibleFilter = '';
    _taskResponsibleFilter = '';
    // _otherFilter = '';
    _statusFilter = '';

    applyFilters();
  }

  @override
  void applyFilters() async {
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }
}
