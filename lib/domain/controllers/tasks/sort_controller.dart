import 'package:get/get.dart';

class TasksSortController extends GetxController {
  var currentSort = 'Deadline'.obs;
  var currentSortOrder = 'ascending'.obs;

  Future<void> changeSort(String newSort) async {
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
  }

  String get sort =>
      '&sortBy=${_toFilters[currentSort.value]}&sortOrder=${currentSortOrder.value}';
}

const _toFilters = {
  'Deadline': 'deadline',
  'Priority': 'priority',
  'Creation date': 'create_on',
  'Start date': 'start_date',
  'Title': 'title',
  'Order': 'sort_order',
};
