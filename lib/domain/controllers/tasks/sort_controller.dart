import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_sort_controller.dart';

class TasksSortController extends BaseSortController {
  @override
  var currentSortText = 'Deadline'.obs;
  @override
  var currentSortOrderText = 'ascending'.obs;

  @override
  String get sort =>
      '&sortBy=${_toFilters[currentSortText.value]}&sortOrder=${currentSortOrderText.value}';

  @override
  // TODO: implement currentSortOrder
  String get currentSortOrder => throw UnimplementedError();

  @override
  // TODO: implement currentSortfilter
  String get currentSortfilter => throw UnimplementedError();

  @override
  String toFilters(value) {
    return _toFilters[value];
  }
}

const _toFilters = {
  'Deadline': 'deadline',
  'Priority': 'priority',
  'Creation date': 'create_on',
  'Start date': 'start_date',
  'Title': 'title',
  'Order': 'sort_order',
};
