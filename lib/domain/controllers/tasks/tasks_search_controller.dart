import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/task/task_service.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';

class TasksSearchController extends BaseController {
  final _api = locator<TaskService>();

  var loaded = true.obs;
  var nothingFound = false.obs;

  String _query;

  final PaginationController _paginationController = PaginationController();
  PaginationController get paginationController => _paginationController;

  var searchInputController = TextEditingController();

  @override
  void onInit() {
    paginationController.startIndex = 0;
    _paginationController.loadDelegate =
        () => _performSearch(needToClear: false);
    paginationController.refreshDelegate = () => newSearch(_query);
    super.onInit();
  }

  @override
  String get screenName => tr('tasksSearch');

  @override
  RxList get itemList => _paginationController.data;

  void newSearch(String query, {bool needToClear = true}) async {
    _query = query.toLowerCase();
    loaded.value = false;

    if (needToClear) paginationController.startIndex = 0;

    if (query == null || query.isEmpty) {
      clearSearch();
    } else {
      await _performSearch(needToClear: needToClear);
    }

    loaded.value = true;
  }

  Future<void> _performSearch({bool needToClear = true}) async {
    nothingFound.value = false;
    var result = await _api.getTasksByParams(
      startIndex: paginationController.startIndex,
      query: _query.toLowerCase(),
    );

    paginationController.total.value = result.total;

    if (result.response.isEmpty) nothingFound.value = true;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response);
  }

  void clearSearch() {
    nothingFound.value = false;
    searchInputController.clear();
    paginationController.data.clear();
  }
}
