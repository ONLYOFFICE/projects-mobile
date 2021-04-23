import 'package:projects/domain/controllers/base_sort_controller.dart';

class ProjectsSortController extends BaseSortController {
  ProjectsSortController() {
    currentSortfilter = 'create_on';
    currentSortTitle.value = getFilterLabel(currentSortfilter);
  }

  @override
  String getFilterLabel(value) {
    return _filtersMapping[value];
  }
}

const _filtersMapping = {
  'create_on': 'Creation date',
  'title': 'Title',
};
