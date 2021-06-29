import 'package:projects/domain/controllers/base_sort_controller.dart';

class TasksSortController extends BaseSortController {
  TasksSortController() {
    currentSortfilter = 'deadline';
    currentSortTitle.value = getFilterLabel(currentSortfilter);
  }
  // @override
  // String getFilterLabel(value) {
  //   return tr(value);
  // }
}

// const _filtersMapping = {
//   'deadline': tr('deadline'),
//   'priority': tr('priority'),
//   'create_on': tr('create_on date'),
//   'start_date': tr('start_date date'),
//   'title': tr('title'),
//   'sort_order': tr('sort_order'),
// };
