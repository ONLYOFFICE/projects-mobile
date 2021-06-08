import 'package:get/get.dart';

abstract class BaseFilterController extends GetxController {
  RxInt suitableResultCount;

  String filtersTitle;

  bool get hasFilters;

  void applyFilters();
  void resetFilters();
  void getSuitableResultCount();
}
