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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/enums/user_status.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersDataSource extends GetxController {
  final _api = locator<UserService>();

  final usersList = <PortalUserItemController>[].obs;
  final loaded = true.obs;
  final searchInputController = TextEditingController();

  final nothingFound = false.obs;
  int _startIndex = 0;
  String _query = '';

  UserSelectionMode selectionMode = UserSelectionMode.Single;

  final isSearchResult = false.obs;

  Timer? _searchDebounce;

  late PortalUserItemController selfUserItem;

  RefreshController _refreshController = RefreshController();
  RefreshController get refreshController {
    if (!_refreshController.isLoading && !_refreshController.isRefresh)
      _refreshController = RefreshController();
    return _refreshController;
  }

  int totalProfiles = 0;

  Future<void> Function()? applyUsersSelection;

  PortalUser? selectedProjectManager;
  final selfIsVisible = true.obs;

  bool get pullUpEnabled => usersList.length != totalProfiles;

  RxList<PortalUserItemController> get usersWithoutVisitors =>
      RxList.from(usersList.where((user) => !user.portalUser.isVisitor!));

  UsersDataSource() {
    final _userController = Get.find<UserController>();
    _userController.updateData();
    _userController.user.listen((user) {
      if (user == null) return;
      selfUserItem = PortalUserItemController(portalUser: _userController.user.value!);
    });
  }

  Future<void> onLoading() async {
    _startIndex += 25;
    if (_startIndex >= totalProfiles) {
      refreshController.loadComplete();
      _startIndex -= 25;
      return;
    }
    await _loadUsers();
    refreshController.loadComplete();
  }

  void searchUsers(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      if (_query != query) {
        loaded.value = false;
        _query = query;
        _startIndex = 0;
        await _loadUsers(needToClear: true);
        loaded.value = true;
      }
    });
  }

  Future _loadUsers({
    bool needToClear = false,
    bool withoutSelf = false,
  }) async {
    nothingFound.value = false;

    if (needToClear) usersList.clear();

    PageDTO<List<PortalUser>>? result;
    if (_query.isEmpty) {
      result = await _api.getProfilesByExtendedFilter(startIndex: _startIndex);
      isSearchResult.value = false;
    } else {
      result = await _api.getProfilesByExtendedFilter(
          startIndex: _startIndex, query: _query.toLowerCase());
      isSearchResult.value = true;
    }
    if (result != null) {
      totalProfiles = result.total;
      if (result.response!.isEmpty) {
        nothingFound.value = true;
      } else {
        for (final user in result.response ?? <PortalUser>[]) {
          final portalUser = PortalUserItemController(portalUser: user);
          portalUser.selectionMode.value = selectionMode;

          usersList.add(portalUser);
        }
      }

      if (withoutSelf) {
        usersList.removeWhere((element) => selfUserItem.portalUser.id == element.id);
      }

      usersList.removeWhere(
          (element) => selectedProjectManager != null && selectedProjectManager!.id == element.id);

      selfIsVisible.value = !(selectedProjectManager?.id != null &&
          selectedProjectManager!.id == selfUserItem.portalUser.id);

      usersList.removeWhere((item) => item.portalUser.status == UserStatus.Terminated);

      if (applyUsersSelection != null) {
        await applyUsersSelection!();
      }
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

  Future getProfiles({required bool needToClear, bool withoutSelf = false}) async {
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
