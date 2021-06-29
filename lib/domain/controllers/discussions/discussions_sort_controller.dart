import 'package:projects/domain/controllers/base_sort_controller.dart';

class DiscussionsSortController extends BaseSortController {
  DiscussionsSortController() {
    currentSortfilter = 'deadline';
    currentSortTitle.value = getFilterLabel(currentSortfilter);
  }
  // @override
  // String getFilterLabel(value) {
  //   return _filtersMapping[value];
  // }
}

// const _filtersMapping = {
//   'deadline': 'Deadline',
//   'priority': 'Priority',
//   'create_on': 'Creation date',
//   'start_date': 'Start date',
//   'title': 'Title',
//   'sort_order': 'Order',
// };
