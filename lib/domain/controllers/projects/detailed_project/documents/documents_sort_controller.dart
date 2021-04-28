import 'package:projects/domain/controllers/base_sort_controller.dart';

class DocumentsSortController extends BaseSortController {
  DocumentsSortController() {
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
  'deadline': 'Deadline',
  'title': 'Title',
};
//TODO: add docs sorting
// title="Дата изменения"
//  title="Дата создания"
//  title="Название"
//  title="Тип"
//   title="Размер"
//    title="Автор"
