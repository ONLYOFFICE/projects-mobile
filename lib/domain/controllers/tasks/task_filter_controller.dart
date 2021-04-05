import 'package:get/get.dart';
import 'package:projects/data/services/task_service.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class TaskFilterController extends GetxController {
  final _api = locator<TaskService>();

  var projectFilters = '';
  var milestoneFilters = '';

  RxInt suitableTasksCount = (-1).obs;
  List filteredTaskList = [];

  RxMap<String, dynamic> responsible = {
    'Me': true,
    'Other': '',
    'Groups': '',
    'No': false,
  }.obs;

  RxMap<String, dynamic> creator = {
    'Me': false,
    'Other': '',
  }.obs;

  RxMap<String, dynamic> project = {
    'My': false,
    'Other': '',
    'With tag': false,
    'Without tag': false,
  }.obs;

  RxMap<String, dynamic> milestone = {
    'My': false,
    'No': false,
    'Other': '',
  }.obs;

  void changeResponsible(String filter, [newValue = '']) {
    switch (filter) {
      case 'Me':
        responsible['Other'] = '';
        responsible['Groups'] = '';
        responsible['No'] = false;
        responsible['Me'] = !responsible['Me'];
        break;
      case 'Other':
        responsible['Me'] = false;
        responsible['Groups'] = '';
        responsible['No'] = false;
        if (newValue == null) {
          responsible['Other'] = '';
        } else {
          responsible['Other'] = newValue['displayName'];
        }
        break;
      case 'Groups':
        responsible['Me'] = false;
        responsible['Other'] = '';
        responsible['No'] = false;
        if (newValue == null) {
          responsible['Groups'] = '';
        } else {
          responsible['Groups'] = 'Some Groups';
        }
        break;
      case 'No':
        responsible['Me'] = false;
        responsible['Other'] = '';
        responsible['Groups'] = '';
        responsible['No'] = !responsible['No'];
        break;
      default:
    }
    // getSuitableTasksCount();
  }

  void changeCreator(String filter, [newValue = '']) {
    if (filter == 'Me') {
      creator['Other'] = '';
      creator['Me'] = !creator['Me'];
    }
    if (filter == 'Other') {
      creator['Me'] = false;
      if (newValue == null) {
        creator['Other'] = '';
      } else {
        creator['Other'] = newValue['displayName'];
      }
    }
    // getSuitableTasksCount();
  }

  void changeProject(String filter, [newValue = '']) async {
    switch (filter) {
      case 'My':
        project['Other'] = '';
        project['My'] = !project['My'];
        break;
      case 'Other':
        project['My'] = false;
        if (newValue == null) {
          project['Other'] = '';
        } else {
          project['Other'] = newValue['title'];
        }
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
    // projectFilters = '';
    // if (project['My']) projectFilters = projectFilters + '&myProjects=true';
    // if (project['Other']) projectFilters = projectFilters + '&myProjects=false';
    // getSuitableTasksCount();
  }

  void changeMilestone(String filter, [newValue]) {
    milestoneFilters = '';
    switch (filter) {
      case 'My':
        milestone['No'] = false;
        milestone['Other'] = '';
        milestone['My'] = !milestone['My'];
        break;
      case 'No':
        milestone['My'] = false;
        milestone['Other'] = '';
        milestone['No'] = !milestone['No'];
        break;
      case 'Other':
        milestone['My'] = false;
        milestone['No'] = false;
        if (newValue == null) {
          milestone['Other'] = '';
        } else {
          milestone['Other'] = 'smth else';
        }
        break;
      default:
    }
    // if (milestone['My']) {
    //   milestoneFilters = milestoneFilters + '&myMilestones=true';
    // }
    // if (project['Other']) {
    //   projectFilters = projectFilters + '&myMilestones=false';
    // }
    // if (milestone['No']) {
    //   milestoneFilters = milestoneFilters + '&nomilestone=true';
    // }
    // getSuitableTasksCount();
  }

  // void getSuitableTasksCount() async {
  //   suitableTasksCount.value = -1;
  //   var fltr = projectFilters + milestoneFilters;
  //   filteredTaskList = await _api.getTasks(params: fltr);

  //   var _myId = await Get.find<UserController>().getUserId();

  //   filteredTaskList = filteredTaskList.where((element) {
  //     var f = true;
  //     // the creator and responsible are filtered locally
  //     // because I didn't find any matching queries
  //     if (creator['Me']) f = f && element.createdBy.id == _myId;
  //     if (creator['Other']) f = f && element.createdBy.id != _myId;
  //     if (responsible['Me']) {
  //       if (element.responsibles != null && !element.responsibles.isEmpty) {
  //         f = f && element.responsibles[0].id == _myId;
  //       } else {
  //         f = false;
  //       }
  //     }
  //     if (responsible['Other']) {
  //       if (element.responsibles != null && !element.responsibles.isEmpty) {
  //         f = f && element.responsibles[0].id != _myId;
  //       } else {
  //         f = false;
  //       }
  //     }
  //     if (responsible['Groups']) {
  //       if (element.responsibles != null && !element.responsibles.isEmpty) {
  //         f = f && element.responsibles.length > 1;
  //       } else {
  //         f = false;
  //       }
  //     }
  //     if (responsible['No']) {
  //       f = f && (element.responsible == null || element.responsibles.isEmpty);
  //     }
  //     return f;
  //   }).toList();

  //   suitableTasksCount.value = filteredTaskList.length;
  // }

  void filter() async {
    var _tasksController = Get.find<TasksController>();
    _tasksController.tasks.value = filteredTaskList;
  }
}
