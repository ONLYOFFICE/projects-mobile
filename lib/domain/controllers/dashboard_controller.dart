import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/projects/projects_with_presets.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_with_presets.dart';
import 'package:projects/internal/locator.dart';

class DashboardController extends GetxController {
  var screenName = tr('dashboard').obs;
  TasksController _myTaskController;
  TasksController _upcomingTaskscontroller;

  ProjectsController _myProjectsController;
  ProjectsController _folowedProjectsController;
  ProjectsController _activeProjectsController;
  var scrollController = ScrollController();

  DashboardController() {
    _myProjectsController = ProjectsWithPresets.myProjectsController;
    _folowedProjectsController = ProjectsWithPresets.folowedProjectsController;
    _activeProjectsController = ProjectsWithPresets.activeProjectsController;
    _myTaskController = TasksWithPresets.myTasksController;
    _upcomingTaskscontroller = TasksWithPresets.upcomingTasksController;

    myTaskController.screenName = tr('myTasks');
    upcomingTaskscontroller.screenName = tr('upcomingTasks');
    myProjectsController.screenName = tr('myProjects');
    folowedProjectsController.screenName = tr('projectsIFolow');
    activeProjectsController.screenName = tr('activeProjects');

    locator<EventHub>().on('needToRefreshProjects', (dynamic data) {
      refreshProjectsData();
    });
  }

  Future<void> refreshData() async {
    await myTaskController.refreshData();
    await upcomingTaskscontroller.refreshData();
  }

  Future<void> refreshProjectsData() async {
    await myProjectsController.loadProjects();
    await folowedProjectsController.loadProjects();
    await activeProjectsController.loadProjects();
  }

  TasksController get myTaskController => _myTaskController;
  TasksController get upcomingTaskscontroller => _upcomingTaskscontroller;

  ProjectsController get myProjectsController => _myProjectsController;
  ProjectsController get folowedProjectsController =>
      _folowedProjectsController;
  ProjectsController get activeProjectsController => _activeProjectsController;
}
