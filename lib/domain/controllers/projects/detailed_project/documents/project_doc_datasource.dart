import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DocsDataSource extends GetxController {
  final _api = locator<FilesService>();
  var docsList = [].obs;
  var loaded = false.obs;
  var searchInputController = TextEditingController();

  var nothingFound = false.obs;
  var _startIndex = 0;
  // var _query = '';
  var multipleSelectionEnabled = false;

  var isSearchResult = false.obs;

  RefreshController refreshController = RefreshController();

  var total;

  Future<void> Function() applyUsersSelection;

  ProjectDetailed projectDetailed;

  bool get pullUpEnabled => docsList.length != total;

  void onLoading() async {
    _startIndex += 25;
    if (_startIndex >= total) {
      refreshController.loadComplete();
      _startIndex -= 25;
      return;
    }
    _loadUsers();
    refreshController.loadComplete();
  }

  void searchUsers(query) {
    loaded.value = false;
    // _query = query;
    _startIndex = 0;
    _loadUsers(needToClear: true);
    loaded.value = true;
  }

  void _loadUsers({bool needToClear = false}) async {
    nothingFound.value = false;

    if (needToClear) docsList.clear();

    var result =
        await _api.getProjectFiles(projectId: projectDetailed.id.toString());

    isSearchResult.value = true;

    // total = result.le;
    if (result.isEmpty) {
      nothingFound.value = true;
    } else {
      docsList.addAll(result);
    }

    if (applyUsersSelection != null) {
      await applyUsersSelection();
    }
  }

  void clearSearch() {
    _clear();
    _loadUsers(needToClear: true);
  }

  void _clear() {
    _startIndex = 0;
    // _query = '';
    docsList.clear();
    searchInputController.clear();
    nothingFound.value = false;
  }

  Future getProfiles({bool needToClear}) async {
    _clear();
    loaded.value = false;
    _loadUsers(needToClear: true);
    loaded.value = true;
  }

  Future<void> updateUsers() async {
    _clear();
    _loadUsers();
  }

  Future getDocs() async {
    loaded.value = false;
    _loadUsers(needToClear: true);
    loaded.value = true;
  }

  reload() {}
}
