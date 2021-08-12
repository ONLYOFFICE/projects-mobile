import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';

class TasksWithPresets {
  static var _myTasksController;
  static var _upcomingTaskscontroller;

  static TasksController get myTasksController {
    setupMyTasks();
    return _myTasksController;
  }

  static TasksController get upcomingTasksController {
    setupMyTasks();
    return _myTasksController;
  }

  static void setupMyTasks() async {
    final _filterController = Get.put(
      TaskFilterController(),
      tag: 'MyTasksContent',
    );

    _myTasksController = Get.put(
      TasksController(
        _filterController,
        Get.put(PaginationController(), tag: 'MyTasksContent'),
      ),
      tag: 'MyTasksContent',
    );
    _myTasksController.expandedCardView.value = true;
    await _filterController
        .setupPreset('myTasks')
        .then((value) => _myTasksController.loadTasks());
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
}
