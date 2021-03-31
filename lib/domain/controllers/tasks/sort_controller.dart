import 'package:get/get.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';

class TasksSortController extends GetxController {
  var currentSort = 'Deadline+'.obs;

  final _taskController = Get.find<TasksController>();

  void sortTasks() async {
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
            (PortalTask a, PortalTask b) => a.priority.compareTo(b.priority));
        break;
      case 'Priority-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.priority.compareTo(a.priority));
        break;
      case 'Creation date+':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => a.priority.compareTo(b.priority));
        break;
      case 'Creation date-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.priority.compareTo(a.priority));
        break;
      case 'Start date+':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => a.priority.compareTo(b.priority));
        break;
      case 'Start date-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.priority.compareTo(a.priority));
        break;
      case 'Title+':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => a.priority.compareTo(b.priority));
        break;
      case 'Title-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.priority.compareTo(a.priority));
        break;
      case 'Other+':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => a.priority.compareTo(b.priority));
        break;
      case 'Other-':
        _taskController.tasks.sort(
            (PortalTask a, PortalTask b) => b.priority.compareTo(a.priority));
        break;
      default:
    }
  }

  void changeCurrentSort(String newSort) {
    currentSort.value = newSort;
    sortTasks();
  }
}
