import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

abstract class BaseSortController extends GetxController {
  RxString currentSortTitle = ''.obs;
  RxBool isSortAscending = true.obs;
  Function updateSortDelegate;

  String currentSortfilter;

  void changeSort(String newSort) async {
    if (newSort == currentSortfilter) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      currentSortfilter = newSort;
      isSortAscending.value = true;
    }
    currentSortTitle.value = getFilterLabel(currentSortfilter);

    if (updateSortDelegate != null) {
      updateSortDelegate();
    }
  }

  String get currentSortOrder =>
      isSortAscending.isTrue ? 'ascending' : 'descending';

  String getFilterLabel(value) => tr(value);
}
