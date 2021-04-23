import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_sort_controller.dart';

class ProjectsSortController extends BaseSortController {
  ProjectsSortController() {
    currentSortText = 'Creation date'.obs;
    currentSortOrderText = 'ascending'.obs;
  }

  @override
  String toFilters(value) {
    return _filtersMapping[value];
  }
}

const _filtersMapping = {
  'Creation date': 'create_on',
  'Title': 'title',
};
