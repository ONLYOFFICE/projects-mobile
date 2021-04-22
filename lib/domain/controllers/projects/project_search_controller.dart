import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  var _totalProjects;

  void onLoading() async {
    _startIndex += 25;
    if (_startIndex >= _totalProjects) {
      refreshController.loadComplete();
      _startIndex -= 25;
      return;
    }
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

    _totalProjects = result.total;

    if (result.response.isEmpty) {
      nothingFound.value = true;
    } else {
      searchResult.addAll(result.response);
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
