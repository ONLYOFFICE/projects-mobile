import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';

class DashboardController extends GetxController {
  var screenName = 'Dashboard'.obs;
  TasksController _myTaskController;
  TasksController _upcomingTaskscontroller;

  ProjectsController _myProjectsController;
  ProjectsController _folowedProjectsController;
  ProjectsController _activeProjectsController;
  var scrollController = ScrollController();

  var needToShowDevider = false.obs;

  DashboardController() {
    setupMyTask();
    setupUpcomingTasks();

    setupMyProjects();
    setupMyFolowedProjects();
    setupActiveProjects();

    scrollController.addListener(
        () => needToShowDevider.value = scrollController.offset > 2);
  }

  TasksController get myTaskController => _myTaskController;
  TasksController get upcomingTaskscontroller => _upcomingTaskscontroller;

  ProjectsController get myProjectsController => _myProjectsController;
  ProjectsController get folowedProjectsController =>
      _folowedProjectsController;
  ProjectsController get activeProjectsController => _activeProjectsController;

  void setupMyTask() {
    final _filterController = Get.put(
      TaskFilterController(),
      tag: 'MyTasksContent',
    );

    _myTaskController = Get.put(
      TasksController(
        _filterController,
        Get.put(PaginationController(), tag: 'MyTasksContent'),
      ),
      tag: 'MyTasksContent',
    );
    _myTaskController.expandedCardView.value = true;
    _filterController
        .setupPreset('myTasks')
        .then((value) => _myTaskController.loadTasks());
  }

  void setupUpcomingTasks() {
    final _filterController = Get.put(
      TaskFilterController(),
      tag: 'UpcommingContent',
    );

    _upcomingTaskscontroller = Get.put(
      TasksController(
        _filterController,
        Get.put(PaginationController(), tag: 'UpcommingContent'),
      ),
      tag: 'UpcommingContent',
    );
    _filterController
        .setupPreset('upcomming')
        .then((value) => _upcomingTaskscontroller.loadTasks());
  }

  void setupMyProjects() {
    final _filterController = Get.put(
      ProjectsFilterController(),
      tag: 'myProjects',
    );

    _myProjectsController = Get.put(
      ProjectsController(
        _filterController,
        Get.put(PaginationController(), tag: 'myProjects'),
      ),
      tag: 'myProjects',
    );

    _filterController
        .setupPreset('myProjects')
        .then((value) => _myProjectsController.loadProjects());
  }

  void setupMyFolowedProjects() {
    final _filterController =
        Get.put(ProjectsFilterController(), tag: 'myFollowedProjects');

    _folowedProjectsController = Get.put(
        ProjectsController(
          _filterController,
          Get.put(PaginationController(), tag: 'myFollowedProjects'),
        ),
        tag: 'myFollowedProjects');
    _filterController
        .setupPreset('myFollowedProjects')
        .then((value) => _folowedProjectsController.loadProjects());
  }

  void setupActiveProjects() {
    final _filterController =
        Get.put(ProjectsFilterController(), tag: 'active');

    _activeProjectsController = Get.put(
        ProjectsController(
          _filterController,
          Get.put(PaginationController(), tag: 'active'),
        ),
        tag: 'active');
    _filterController
        .setupPreset('active')
        .then((value) => _activeProjectsController.loadProjects());
  }
}
