import 'package:get/get.dart';

abstract class BaseFilterController extends GetxController {
  RxInt suitableTasksCount;

  String filtersTitle;

  bool get hasFilters;

  void applyFilters() {}

  void resetFilters() {}
}
