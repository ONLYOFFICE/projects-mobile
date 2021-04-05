import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';

class TasksSortController extends GetxController {
  var currentSort = 'Deadline'.obs;
  var currentSortOrder = 'ascending'.obs;

  final _taskController = Get.find<TasksController>();

  Future<void> sortTasks(String newSort) async {
    if (newSort == currentSort.value) {
      if (currentSortOrder.value == 'ascending') {
        currentSortOrder.value = 'descending';
      } else {
        currentSortOrder.value = 'ascending';
      }
    } else {
      currentSort.value = newSort;
      currentSortOrder.value == 'ascending';
    }

    var toFilters = {
      'Deadline': 'deadline',
      'Priority': 'priority',
      'Creation date': 'create_on',
      'Start date': 'start_date',
      'Title': 'title',
      'Order': 'sort_order',
    };

    var params =
        '&sortBy=${toFilters[currentSort.value]}&sortOrder=${currentSortOrder.value}';
    await _taskController.getTasks(params: params);
  }
}
