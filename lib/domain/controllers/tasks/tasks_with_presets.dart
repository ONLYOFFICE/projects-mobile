import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';

class TasksWithPresets {
  static var _myTasksController;

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

  static TasksController get myTasksController {
    setupMyTasks();
    return _myTasksController;
  }
}
