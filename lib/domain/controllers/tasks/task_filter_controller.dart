import 'package:get/get.dart';
import 'package:projects/data/services/tasks_service.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class TaskFilterController extends GetxController {
  final _api = locator<TasksService>();

  var projectFilters = '';
  var milestoneFilters = '';

  RxInt suitableTasksCount = (-1).obs;
  List filteredTaskList = [];

  RxMap<String, bool> responsible =
      {'Me': true, 'Other': false, 'Groups': false, 'No': false}.obs;

  RxMap creator = {'Me': false, 'Other': false}.obs;

  RxMap project = {
    'My': false,
    'Other': false,
    'With tag': false,
    'Without tag': false
  }.obs;

  RxMap milestone = {'My': false, 'No': false, 'Other': false}.obs;

  void changeResponsible(String filter) {
    for (var item in responsible.keys) {
      if (item != filter) responsible.update(item, (value) => false);
    }
    responsible[filter] = !responsible[filter];
    getSuitableTasksCount();
  }

  void changeCreator(String filter) {
    if (filter == 'Me') creator['Other'] = false;
    if (filter == 'Other') creator['Me'] = false;
    creator[filter] = !creator[filter];
    getSuitableTasksCount();
  }

  void changeProject(String filter) async {
    switch (filter) {
      case 'My':
        project['Other'] = false;
        project['My'] = !project['My'];
        break;
      case 'Other':
        project['My'] = false;
        project['Other'] = !project['Other'];
        break;
      case 'With tag':
        project['Without tag'] = false;
        project['With tag'] = !project['With tag'];
        break;
      case 'Without tag':
        project['With tag'] = false;
        project['Without tag'] = !project['Without tag'];
        break;
      default:
    }
    projectFilters = '';
    if (project['My']) projectFilters = projectFilters + '&myProjects=true';
    if (project['Other']) projectFilters = projectFilters + '&myProjects=false';
    getSuitableTasksCount();
  }

  void changeMilestone(String filter) {
    for (var item in milestone.keys) {
      if (item != filter) milestone.update(item, (value) => false);
    }
    milestone[filter] = !milestone[filter];
    milestoneFilters = '';
    if (milestone['My']) {
      milestoneFilters = milestoneFilters + '&myMilestones=true';
    }
    if (project['Other']) {
      projectFilters = projectFilters + '&myMilestones=false';
    }
    if (milestone['No']) {
      milestoneFilters = milestoneFilters + '&nomilestone=true';
    }
    getSuitableTasksCount();
  }

  void getSuitableTasksCount() async {
    suitableTasksCount.value = -1;
    var fltr = projectFilters + milestoneFilters;
    filteredTaskList = await _api.getTasks(filter: fltr);

    var _myId = await Get.find<UserController>().getUserId();

    filteredTaskList = filteredTaskList.where((element) {
      var f = true;
      // the creator and responsible are filtered locally
      // because I didn't find any matching queries
      if (creator['Me']) f = f && element.createdBy.id == _myId;
      if (creator['Other']) f = f && element.createdBy.id != _myId;
      if (responsible['Me']) {
        if (element.responsibles != null && !element.responsibles.isEmpty) {
          f = f && element.responsibles[0].id == _myId;
        } else {
          f = false;
        }
      }
      if (responsible['Other']) {
        if (element.responsibles != null && !element.responsibles.isEmpty) {
          f = f && element.responsibles[0].id != _myId;
        } else {
          f = false;
        }
      }
      if (responsible['Groups']) {
        if (element.responsibles != null && !element.responsibles.isEmpty) {
          f = f && element.responsibles.length > 1;
        } else {
          f = false;
        }
      }
      if (responsible['No']) {
        f = f && (element.responsible == null || element.responsibles.isEmpty);
      }
      return f;
    }).toList();

    suitableTasksCount.value = filteredTaskList.length;
  }

  void filter() async {
    var _tasksController = Get.find<TasksController>();
    _tasksController.tasks.value = filteredTaskList;
  }
}
