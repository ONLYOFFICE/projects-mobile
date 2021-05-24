import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DocsDataSource extends GetxController {
  final _api = locator<FilesService>();
  var docsList = [].obs;
  var foldersList = [].obs;
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
    _loadDocs();
    refreshController.loadComplete();
  }

  void searchUsers(query) {
    loaded.value = false;
    // _query = query;
    _startIndex = 0;
    _loadDocs(needToClear: true);
    loaded.value = true;
  }

  void _loadDocs({bool needToClear = false}) async {
    nothingFound.value = false;

    if (needToClear) docsList.clear();
    var result;
    if (projectDetailed != null) {
      result =
          await _api.getProjectFiles(projectId: projectDetailed.id.toString());

      isSearchResult.value = true;

      if (result.isEmpty) {
        nothingFound.value = true;
      } else {
        docsList.addAll(result);
      }
    } else {
      result = await _api.getFiles();

      isSearchResult.value = true;

      if (result.isEmpty) {
        nothingFound.value = true;
      } else {
        foldersList.addAll(result);
      }
    }

    if (applyUsersSelection != null) {
      await applyUsersSelection();
    }
  }

  void clearSearch() {
    _clear();
    _loadDocs(needToClear: true);
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
    _loadDocs(needToClear: true);
    loaded.value = true;
  }

  Future<void> updateUsers() async {
    _clear();
    _loadDocs();
  }

  Future getDocs() async {
    loaded.value = false;
    _loadDocs(needToClear: true);
    loaded.value = true;
  }

  reload() {}
}
