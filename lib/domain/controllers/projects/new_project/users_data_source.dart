import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
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

  var selectionMode = UserSelectionMode.Single;

  var isSearchResult = false.obs;

  // var withoutSelf_remove = false;
  PortalUserItemController selfUserItem;

  RefreshController refreshController = RefreshController();

  var totalProfiles;

  Future<void> Function() applyUsersSelection;

  PortalUser selectedProjectManager;
  var selfIsVisible = true.obs;

  bool get pullUpEnabled => usersList.length != totalProfiles;

  void onLoading() async {
    _startIndex += 25;
    if (_startIndex >= totalProfiles) {
      refreshController.loadComplete();
      _startIndex -= 25;
      return;
    }
    await _loadUsers();
    refreshController.loadComplete();
  }

  void searchUsers(query) {
    loaded.value = false;
    _query = query;
    _startIndex = 0;
    _loadUsers(needToClear: true);
    loaded.value = true;
  }

  Future _loadUsers({
    bool needToClear = false,
    bool withoutSelf = false,
  }) async {
    nothingFound.value = false;

    if (needToClear) usersList.clear();

    var result;
    if (_query == null || _query.isEmpty) {
      result = await _api.getProfilesByExtendedFilter(startIndex: _startIndex);
      isSearchResult.value = false;
    } else {
      result = await _api.getProfilesByExtendedFilter(
          startIndex: _startIndex, query: _query.toLowerCase());
      isSearchResult.value = true;
    }
    totalProfiles = result.total;
    if (result.response.isEmpty) {
      nothingFound.value = true;
    } else {
      for (var user in result.response) {
        var portalUser = PortalUserItemController(portalUser: user);
        portalUser.selectionMode.value = selectionMode;

        usersList.add(portalUser);
      }
    }

    if (withoutSelf) {
      usersList
          .removeWhere((element) => selfUserItem?.portalUser?.id == element.id);
    }

    usersList.removeWhere((element) =>
        selectedProjectManager != null &&
        selectedProjectManager.id == element.id);

    selfIsVisible.value = !(selectedProjectManager != null &&
        selectedProjectManager.id == selfUserItem.portalUser.id);

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
    _query = '';
    usersList.clear();
    searchInputController.clear();
    nothingFound.value = false;
  }

  Future getProfiles({bool needToClear, withoutSelf = false}) async {
    _clear();
    loaded.value = false;
    await _loadUsers(needToClear: needToClear, withoutSelf: withoutSelf);
    loaded.value = true;
  }

  Future<void> updateUsers() async {
    _clear();
    await _loadUsers();
  }
}
