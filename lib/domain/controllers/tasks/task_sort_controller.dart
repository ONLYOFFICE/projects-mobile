import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_sort_controller.dart';

class TasksSortController extends BaseSortController {
  TasksSortController() {
    currentSortText.value = 'Deadline';
    currentSortOrderText.value = 'ascending';
  }
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
