import 'package:get/get.dart';
import 'package:projects/data/services/task_service.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class TaskFilterController extends BaseFilterController {
  final _api = locator<TaskService>();

  final _sortController = Get.find<TasksSortController>();
  Function applyFiltersDelegate;

  // only accepted filters
  RxString acceptedFilters = ''.obs;

  String _responsibleFilter = '';
  String _creatorFilter = '';
  String _projectFilter = '';
  String _milestoneFilter = '';

  @override
  var filtersTitle = 'TASKS';

  String get responsibleFilter => _responsibleFilter;
  String get creatorFilter => _creatorFilter;
  String get projectFilter => _projectFilter;
  String get milestoneFilter => _milestoneFilter;

  var _selfId;

  @override
  RxInt suitableTasksCount = (-1).obs;

  @override
  bool get hasFilters =>
      _responsibleFilter.isNotEmpty ||
      _creatorFilter.isNotEmpty ||
      _projectFilter.isNotEmpty ||
      _milestoneFilter.isNotEmpty;

  RxMap<String, dynamic> responsible =
      {'Me': false, 'Other': '', 'Groups': '', 'No': false}.obs;

  RxMap<String, dynamic> creator = {'Me': false, 'Other': ''}.obs;

  RxMap<String, dynamic> project =
      {'My': false, 'Other': '', 'With tag': '', 'Without tag': false}.obs;

  RxMap<String, dynamic> milestone =
      {'My': false, 'No': false, 'Other': ''}.obs;

  void changeResponsible(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _responsibleFilter = '';

    switch (filter) {
      case 'Me':
        responsible['Other'] = '';
        responsible['Groups'] = '';
        responsible['No'] = false;
        responsible['Me'] = !responsible['Me'];
        if (responsible['Me']) _responsibleFilter = '&participant=$_selfId';
        break;
      case 'Other':
        responsible['Me'] = false;
        responsible['Groups'] = '';
        responsible['No'] = false;
        if (newValue == null) {
          responsible['Other'] = '';
        } else {
          responsible['Other'] = newValue['displayName'];
          _responsibleFilter = '&participant=${newValue["id"]}';
        }
        break;
      case 'Groups':
        responsible['Me'] = false;
        responsible['Other'] = '';
        responsible['No'] = false;
        if (newValue == null) {
          responsible['Groups'] = '';
        } else {
          responsible['Groups'] = newValue['name'];
          _responsibleFilter = '&departament=${newValue["id"]}';
        }
        break;
      case 'No':
        responsible['Me'] = false;
        responsible['Other'] = '';
        responsible['Groups'] = '';
        responsible['No'] = !responsible['No'];
        if (responsible['No']) {
          _responsibleFilter =
              '&participant=00000000-0000-0000-0000-000000000000';
        }
        break;
      default:
    }
    getSuitableTasksCount();
  }

  void changeCreator(String filter, [newValue = '']) {
    _creatorFilter = '';
    if (filter == 'Me') {
      creator['Other'] = '';
      creator['Me'] = !creator['Me'];
      if (creator['Me']) _creatorFilter = '&creator=$_selfId';
    }
    if (filter == 'Other') {
      creator['Me'] = false;
      if (newValue == null) {
        creator['Other'] = '';
      } else {
        creator['Other'] = newValue['displayName'];
        _creatorFilter = '&creator=${newValue["id"]}';
      }
    }
    getSuitableTasksCount();
  }

  void changeProject(String filter, [newValue = '']) async {
    _projectFilter = '';
    switch (filter) {
      case 'My':
        project['Other'] = '';
        project['With tag'] = '';
        project['Without tag'] = false;
        project['My'] = !project['My'];
        if (project['My']) _projectFilter = '&myprojects=true';
        break;
      case 'Other':
        project['My'] = false;
        project['With tag'] = '';
        project['Without tag'] = false;
        if (newValue == null) {
          project['Other'] = '';
        } else {
          project['Other'] = newValue['title'];
          _projectFilter = '&projectId=${newValue["id"]}';
        }
        break;
      case 'With tag':
        project['My'] = false;
        project['Other'] = '';
        project['Without tag'] = false;
        if (newValue == null) {
          project['With tag'] = '';
        } else {
          project['With tag'] = newValue['title'];
          _projectFilter = '&tag=${newValue["id"]}';
        }
        break;
      case 'Without tag':
        project['My'] = false;
        project['Other'] = '';
        project['With tag'] = '';
        project['Without tag'] = !project['Without tag'];
        if (project['Without tag']) _projectFilter = '&tag=-1';
        break;
      default:
    }
    getSuitableTasksCount();
  }

  void changeMilestone(String filter, [newValue]) {
    _milestoneFilter = '';
    switch (filter) {
      case 'My':
        milestone['No'] = false;
        milestone['Other'] = '';
        milestone['My'] = !milestone['My'];
        if (milestone['My']) _milestoneFilter = '&mymilestones=true';
        break;
      case 'No':
        milestone['My'] = false;
        milestone['Other'] = '';
        milestone['No'] = !milestone['No'];
        if (milestone['No']) _milestoneFilter = '&nomilestone=true';
        break;
      case 'Other':
        milestone['My'] = false;
        milestone['No'] = false;
        if (newValue == null) {
          milestone['Other'] = '';
        } else {
          milestone['Other'] = newValue['title'];
          _milestoneFilter = '&milestone=${newValue["id"]}';
        }
        break;
      default:
    }
    getSuitableTasksCount();
  }

  void getSuitableTasksCount() async {
    suitableTasksCount.value = -1;

    var result = await _api.getTasksByParams(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      responsibleFilter: responsibleFilter,
      creatorFilter: creatorFilter,
      projectFilter: projectFilter,
      milestoneFilter: milestoneFilter,
    );

    suitableTasksCount.value = result.response.length;
  }

  @override
  void resetFilters() async {
    responsible.value = {'Me': false, 'Other': '', 'Groups': '', 'No': false};
    creator.value = {'Me': false, 'Other': ''};
    project.value = {
      'My': false,
      'Other': '',
      'With tag': '',
      'Without tag': false
    };
    milestone.value = {'My': false, 'No': false, 'Other': ''};
    acceptedFilters.value = '';
    suitableTasksCount.value = -1;

    _responsibleFilter = '';
    _creatorFilter = '';
    _projectFilter = '';
    _milestoneFilter = '';

    applyFilters();
  }

  @override
  void applyFilters() async {
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }
}
