import 'package:get/get.dart';

abstract class BaseFilterController extends GetxController {
  RxInt suitableResultCount;

  String filtersTitle;

  RxBool hasFilters = false.obs;

  void applyFilters();
  void resetFilters();
  void getSuitableResultCount();

  void saveFilters();
  void loadFilters();

  Map dateTimesToString(Map map) {
    map.forEach((key, value) {
      if (value is DateTime) map[key] = map[key].toIso8601String();
    });
    return map;
  }

  Map stringsToDateTime(Map map, List keysToConvert) {
    for (var item in keysToConvert) {
      map[item] = DateTime.parse(map[item]);
    }
    return map;
  }
}
