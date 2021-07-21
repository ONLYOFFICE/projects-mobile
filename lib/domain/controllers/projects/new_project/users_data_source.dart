/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

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

  var withoutSelf = false;
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
      usersList.removeWhere((element) =>
          selfUserItem.portalUser.id == element.id ||
          (selectedProjectManager != null &&
              selectedProjectManager.id == element.id));
    }

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
}
