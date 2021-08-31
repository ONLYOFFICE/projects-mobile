import 'package:projects/domain/controllers/base/base_sort_controller.dart';

class MilestonesSortController extends BaseSortController {
  MilestonesSortController() {
    currentSortfilter = 'create_on';
    currentSortTitle.value = getFilterLabel(currentSortfilter);
  }

  // @override
  // String getFilterLabel(value) {
  //   return _filtersMapping[value];
  // }
}

// const _filtersMapping = {
//   'create_on': 'Creation date',
//   'deadline': 'Deadline',
//   'title': 'Title',
// };
