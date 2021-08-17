import 'package:get/get.dart';

abstract class BaseFilterController extends GetxController {
  RxInt suitableResultCount;

  String filtersTitle;

  RxBool hasFilters = false.obs;

  void applyFilters();
  void resetFilters();
  void getSuitableResultCount();
}
