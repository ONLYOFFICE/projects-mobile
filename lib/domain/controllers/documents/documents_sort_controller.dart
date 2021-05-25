import 'package:projects/domain/controllers/base_sort_controller.dart';

class DocumentsSortController extends BaseSortController {
  DocumentsSortController() {
    currentSortfilter = 'title';
    currentSortTitle.value = getFilterLabel(currentSortfilter);
  }

  @override
  String getFilterLabel(value) {
    return _filtersMapping[value];
  }
}

const _filtersMapping = {
  'dateandtime': 'Last modified date',
  'create_on': 'Creation date',
  'title': 'Title',
  'type': 'Type',
  'size': 'Size',
  'author': 'Author',
};
