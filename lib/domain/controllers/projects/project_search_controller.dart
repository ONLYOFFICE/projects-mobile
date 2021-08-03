import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectSearchController extends GetxController {
  final _api = locator<ProjectService>();
  final onlyMyProjects;

  ProjectSearchController({this.onlyMyProjects = false});

  var searchResult = [].obs;
  var loaded = true.obs;
  var searchInputController = TextEditingController();

  var nothingFound = false.obs;
  // for select project view
  var switchToSearchView = false.obs;
  var _startIndex;
  var _query;
  var _selfId;

  RefreshController refreshController = RefreshController();

  var _totalProjects;

  @override
  void onInit() async {
    if (onlyMyProjects) {
      _selfId = await Get.find<UserController>().getUserId();
      _query = '&participant=$_selfId';
    }
    super.onInit();
  }

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
    if (onlyMyProjects) _query += '&participant=$_selfId';
    _startIndex = 0;
    _performSearch();
  }

  void _performSearch() async {
    loaded.value = false;
    nothingFound.value = false;
    switchToSearchView.value = true;
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
    _query = onlyMyProjects ? '&participant=$_selfId' : '';
    searchResult.clear();
    searchInputController.clear();
    nothingFound.value = false;
    switchToSearchView.value = false;
  }
}
