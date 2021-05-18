import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  String get screenName;
  RxList<dynamic> get itemList;
  var hasFilters = false.obs;

  var showAll = false.obs;
  var expandedCardView = false.obs;

  void showSearch() {}
}
