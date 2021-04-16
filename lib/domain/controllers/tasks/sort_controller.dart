import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_sort_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';

class TasksSortController extends BaseSortController {
  @override
  var currentSortText = 'Deadline'.obs;
  @override
  var currentSortOrderText = 'ascending'.obs;

  @override
  void changeSort(String newSort) {
    super.changeSort(newSort);
    Get.find<TasksController>().getTasks();
  }

  @override
  String get sort =>
      '&sortBy=${_filtersMapping[currentSortText.value]}&sortOrder=${currentSortOrderText.value}';

  @override
  // TODO: implement currentSortOrder
  String get currentSortOrder => throw UnimplementedError();

  @override
  // TODO: implement currentSortfilter
  String get currentSortfilter => throw UnimplementedError();

  @override
  String toFilters(value) {
    return _filtersMapping[value];
  }
}

const _filtersMapping = {
  'Deadline': 'deadline',
  'Priority': 'priority',
  'Creation date': 'create_on',
  'Start date': 'start_date',
  'Title': 'title',
  'Order': 'sort_order',
};
