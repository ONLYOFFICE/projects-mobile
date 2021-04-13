import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/projects/portal_user_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersDataSource extends GetxController {
  final _api = locator<UserService>();
  var usersList = [].obs;
  var loaded = true.obs;
  var searchInputController = TextEditingController();

  var nothingFound = false.obs;
  var _startIndex = 0;
  var _query = '';
  var multipleSelectionEnabled = false;

  var isSearchResult = false.obs;

  RefreshController refreshController = RefreshController();

  var totalProfiles;

  Future<void> Function() presets;

  bool get pullUpEnabled => usersList.length != totalProfiles;

  void onLoading() async {
    _startIndex += 25;
    if (_startIndex >= totalProfiles) {
      refreshController.loadComplete();
      _startIndex -= 25;
      return;
    }
    _loadUsers();
    refreshController.loadComplete();
  }

  void searchUsers(query) {
    loaded.value = false;
    _query = query;
    _startIndex = 0;
    _loadUsers(needToClear: true);
    loaded.value = true;
  }

  void _loadUsers({bool needToClear = false}) async {
    nothingFound.value = false;

    if (needToClear) usersList.clear();

    var result;
    if (_query == null || _query.isEmpty) {
      result = await _api.getProfilesByParams(startIndex: _startIndex);
      isSearchResult.value = false;
    } else {
      result = await _api.getProfilesByParams(
          startIndex: _startIndex, query: _query.toLowerCase());
      isSearchResult.value = true;
    }
    totalProfiles = result.total;
    if (result.response.isEmpty) {
      nothingFound.value = true;
    } else {
      result.response.forEach(
        (element) {
          var portalUser = PortalUserItemController(portalUser: element);
          portalUser.multipleSelectionEnabled.value = multipleSelectionEnabled;
          usersList.add(portalUser);
        },
      );
    }

    if (presets != null) {
      await presets();
    }
  }

  void clearSearch() {
    _clear();
    _loadUsers(needToClear: true);
  }

  void _clear() {
    _startIndex = 0;
    _query = '';
    usersList.clear();
    searchInputController.clear();
    nothingFound.value = false;
  }

  Future getProfiles({bool needToClear}) async {
    _clear();
    loaded.value = false;
    _loadUsers(needToClear: true);
    loaded.value = true;
  }
}
