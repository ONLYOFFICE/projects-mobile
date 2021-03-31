import 'package:get/get.dart';
import 'package:projects/data/services/tasks_service.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/internal/locator.dart';

class TaskFilterController extends GetxController {
  final _api = locator<TasksService>();

  var projectFilters = '';
  RxInt suitableTasksCount = (-1).obs;
  List filteredTaskList = [];

  RxMap<String, bool> responsible = {
    'Me': false,
    'Other': false,
    'Groups': false,
    'No responsible': false
  }.obs;

  RxMap creator = {'Me': false, 'Other': false}.obs;

  RxMap project = {
    'My': false,
    'Other': false,
    'With tag': false,
    'Without tag': false
  }.obs;

  RxMap milestone = {'My': false, 'No': false, 'Other': false}.obs;

  void changeResponsible(String filter) {
    responsible.updateAll((key, value) => false);
    responsible[filter] = !responsible[filter];
  }

  void changeCreator(String filter) {
    creator.updateAll((key, value) => false);
    creator[filter] = !creator[filter];
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
    milestone.updateAll((key, value) => false);
    milestone[filter] = !milestone[filter];
  }

  void getSuitableTasksCount() async {
    suitableTasksCount.value = -1;
    filteredTaskList = await _api.getTasks(filter: projectFilters);
    suitableTasksCount.value = filteredTaskList.length;
  }

  void filter() async {
    var _tasksController = Get.find<TasksController>();
    _tasksController.tasks.value = filteredTaskList;
  }
}
