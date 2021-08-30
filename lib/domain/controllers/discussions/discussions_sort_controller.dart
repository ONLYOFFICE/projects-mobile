import 'package:projects/domain/controllers/base/base_sort_controller.dart';

class DiscussionsSortController extends BaseSortController {
  DiscussionsSortController() {
    currentSortfilter = 'create_on';
    currentSortTitle.value = getFilterLabel(currentSortfilter);
  }
}
