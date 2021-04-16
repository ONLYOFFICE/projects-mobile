import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_sort_controller.dart';

class ProjectsSortController extends BaseSortController {
  @override
  var currentSortText = 'Creation date'.obs;
  @override
  var currentSortOrderText = 'ascending'.obs;

  @override
  String get sort =>
      '&sortBy=${_toFilters[currentSortText.value]}&sortOrder=${currentSortOrderText.value}';

  @override
  String toFilters(value) {
    return _toFilters[value];
  }
}

const _toFilters = {
  'Creation date': 'create_on',
  'Title': 'title',
};
