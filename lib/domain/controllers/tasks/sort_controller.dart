import 'package:get/get.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';

class TasksSortController extends GetxController {
  var currentSort = 'Deadline+'.obs;

  final _taskController = Get.find<TasksController>();

  Future<void> sortTasks() async {
    print(currentSort.value);
    _taskController.loaded.value = false;
    switch (currentSort.value) {
      case 'Deadline+':
        _taskController.tasks
            .sort((PortalTask a, PortalTask b) => a.title.compareTo(b.title));
        break;
      case 'Deadline-':
        _taskController.tasks
            .sort((PortalTask a, PortalTask b) => b.title.compareTo(a.title));
        break;
      case 'Priority+':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.priority.compareTo(a.priority));
        break;
      case 'Priority-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => a.priority.compareTo(b.priority));
        break;
      case 'Creation date+':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => a.created.compareTo(b.created));
        break;
      case 'Creation date-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.created.compareTo(a.created));
        break;
      case 'Start date+':
        _taskController.tasks.sort((PortalTask a, PortalTask b) {
          return a.startDate.compareTo(b.startDate);
        });
        break;
      case 'Start date-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.startDate.compareTo(a.startDate));
        break;
      case 'Title+':
        _taskController.tasks
            .sort((PortalTask a, PortalTask b) => a.title.compareTo(b.title));
        break;
      case 'Title-':
        _taskController.tasks
            .sort((PortalTask a, PortalTask b) => b.title.compareTo(a.title));
        break;
      case 'Order+':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => a.priority.compareTo(b.priority));
        break;
      case 'Order-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.priority.compareTo(a.priority));
        break;
      default:
    }
    _taskController.loaded.value = true;
  }

  void changeCurrentSort(String newSort) {
    if (currentSort.value.startsWith(newSort)) {
      currentSort.value.endsWith('+') ? newSort += '-' : newSort += '+';
    } else {
      newSort += '+';
    }
    currentSort.value = newSort;
    sortTasks();
  }
}
