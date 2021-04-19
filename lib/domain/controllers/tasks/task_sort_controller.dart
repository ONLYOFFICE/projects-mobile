import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_sort_controller.dart';

class TasksSortController extends BaseSortController {
  @override
  var currentSortText = 'Deadline'.obs;
  @override
  var currentSortOrderText = 'ascending'.obs;

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
