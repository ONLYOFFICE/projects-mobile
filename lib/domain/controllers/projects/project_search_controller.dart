import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/item.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectSearchController extends GetxController {
  final _api = locator<ProjectService>();
  var searchResult = [].obs;
  var loaded = true.obs;
  var searchInputController = TextEditingController();

  var nothingFound = false.obs;
  var _startIndex;
  var _query;

  RefreshController refreshController = RefreshController();

  void onLoading() async {
    _startIndex++;
    _performSearch();
    refreshController.loadComplete();
  }

  void newSearch(query) {
    _query = query;
    _startIndex = 0;
    _performSearch();
  }

  void _performSearch() async {
    loaded.value = false;
    nothingFound.value = false;
    searchResult.clear();

    var result = await _api.getProjectsByParams(
        startIndex: _startIndex, query: _query.toLowerCase());

    if (result.isEmpty) {
      nothingFound.value = true;
    } else {
      result.forEach(
        (element) {
          searchResult.add(Item(
            id: element.id,
            title: element.title,
            status: element.status,
            responsible: element.responsible,
            date: element.creationDate(),
            subCount: element.taskCount,
            isImportant: false,
          ));
        },
      );
    }
    loaded.value = true;
  }

  void clearSearch() {
    _startIndex = 0;
    _query = '';
    searchResult.clear();
    searchInputController.clear();
    nothingFound.value = false;
  }
}
