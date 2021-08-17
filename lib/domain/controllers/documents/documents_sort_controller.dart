import 'package:projects/domain/controllers/base/base_sort_controller.dart';

class DocumentsSortController extends BaseSortController {
  DocumentsSortController() {
    currentSortfilter = 'AZ';
    currentSortTitle.value = getFilterLabel(currentSortfilter);
  }

  // @override
  // String getFilterLabel(value) {
  //   return _filtersMapping[value];
  // }
}

// const _filtersMapping = {
//   'dateandtime': 'Last modified date',
//   'create_on': 'Creation date',
//   'AZ': 'Title',
//   'type': 'Type',
//   'size': 'Size',
//   'author': 'Author',
// };
