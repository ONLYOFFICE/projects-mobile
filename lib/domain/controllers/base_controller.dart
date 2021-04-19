import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  String get screenName;
  RxList<dynamic> get itemList;
  var hasFilters = false.obs;

  void showSearch() {}
}
