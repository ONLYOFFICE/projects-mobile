import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';

abstract class BaseSearchController extends GetxController {
  BaseSearchController({this.paginationController});

  final PaginationController paginationController;
  final TextEditingController textController = TextEditingController();

  String _query;

  RxBool loaded = false.obs;
  RxBool switchToSearchView = false.obs;

  bool get nothingFound =>
      switchToSearchView.isTrue &&
      paginationController.data.isEmpty &&
      textController.text.isNotEmpty &&
      loaded.isTrue;

  bool get hasResult =>
      loaded.isTrue &&
      switchToSearchView.isTrue &&
      paginationController.data.isNotEmpty;

  Future search({needToClear = true, String query});
  Future<void> performSearch({needToClear = true, String query}) async {}

  void addData(var result, bool needToClear) {
    if (result != null) {
      paginationController.total.value = result.total;
      if (needToClear) paginationController.data.clear();
      paginationController.data.addAll(result.response);
    }
  }

  Future<void> refreshData() async {
    loaded.value = false;
    await performSearch(needToClear: true, query: _query);
    loaded.value = true;
  }

  void clearSearch() {
    paginationController.data.clear();
    textController.clear();
    _query = null;
  }
}
