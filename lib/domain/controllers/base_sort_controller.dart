import 'package:get/get.dart';

abstract class BaseSortController extends GetxController {
  var currentSortText;
  var currentSortOrderText;
  Function updateSortDelegate;

  Future<void> changeSort(String newSort) async {
    if (newSort == currentSortText.value) {
      if (currentSortOrderText.value == 'ascending') {
        currentSortOrderText.value = 'descending';
      } else {
        currentSortOrderText.value = 'ascending';
      }
    } else {
      currentSortText.value = newSort;
      currentSortOrderText.value == 'ascending';
    }

    if (updateSortDelegate != null) {
      updateSortDelegate();
    }
  }

  String get sort;

  String get currentSortfilter => toFilters(currentSortText.value);

  String get currentSortOrder => currentSortOrderText.value;

  String toFilters(value);
}
