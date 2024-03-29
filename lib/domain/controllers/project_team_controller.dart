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

import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/enums/user_status.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectTeamController extends GetxController {
  final _api = locator<ProjectService>();

  final usersList = <PortalUserItemController>[].obs;
  final loaded = true.obs;
  final nothingFound = false.obs;
  var _startIndex = 0;

  RefreshController _refreshController = RefreshController();

  RefreshController get refreshController {
    if (!_refreshController.isLoading && !_refreshController.isRefresh)
      _refreshController = RefreshController();
    return _refreshController;
  }

  int totalProfiles = 0;
  int _projectId = 0;
  final isSearchResult = false.obs;
  final searchResult = <PortalUserItemController>[].obs;
  UserSelectionMode selectionMode = UserSelectionMode.None;

  bool _withoutVisitors = false;
  bool _withoutBlocked = false;
  final fabIsVisible = false.obs;

  ProjectDetailed? _projectDetailed;

  bool get pullUpEnabled => usersList.length != totalProfiles;

  late final StreamSubscription _ss;
  ProjectTeamController() {
    getFabVisibility(Get.find<UserController>().user.value);
    _ss = Get.find<UserController>().user.listen(getFabVisibility);
  }

  @override
  void onClose() {
    _ss.cancel();

    super.onClose();
  }

  Future onLoading() async {
    _startIndex += 25;
    if (_startIndex >= totalProfiles) {
      _refreshController.loadComplete();
      _startIndex -= 25;
      return;
    }
    await _loadTeam();
    _refreshController.loadComplete();
  }

  Future<bool> _loadTeam({bool needToClear = false}) async {
    final result = await _api.getProjectTeam(_projectId);

    if (result == null) return Future.value(false);

    totalProfiles = result.length;

    if (needToClear) usersList.clear();

    for (final element in result) {
      if (_withoutVisitors && element.isVisitor!) continue;
      if (_withoutBlocked && element.status == UserStatus.Terminated) {
        continue;
      }

      final portalUser = PortalUserItemController(portalUser: element);
      portalUser.selectionMode.value = selectionMode;
      usersList.add(portalUser);
    }

    nothingFound.value = usersList.isEmpty;

    return Future.value(true);
  }

  Future<bool> getTeam({bool needToClear = true}) async {
    loaded.value = false;

    await _loadTeam(needToClear: needToClear);

    if (_projectDetailed?.status == ProjectStatusCode.closed.index) {
      _ss.pause();
      fabIsVisible.value = false;
    } else {
      _ss.resume();
      getFabVisibility(Get.find<UserController>().user.value);
    }

    loaded.value = true;
    return true;
  }

  void searchUsers(String query) {
    searchResult.clear();
    if (query == '') {
      nothingFound.value = usersList.isEmpty;
      isSearchResult.value = false;
    }
    isSearchResult.value = true;
    searchResult.addAll(
        usersList.where((user) => user.displayName!.toLowerCase().contains(query.toLowerCase())));

    nothingFound.value = searchResult.isEmpty;
  }

  void clearSearch() {
    searchResult.clear();
    isSearchResult.value = false;
  }

  void setup(
      {ProjectDetailed? projectDetailed,
      bool withoutVisitors = false,
      bool withoutBlocked = false,
      int? projectId}) {
    _withoutVisitors = withoutVisitors;
    _withoutBlocked = withoutBlocked;
    _projectId = projectId ?? projectDetailed!.id!;
    _projectDetailed = projectDetailed;
  }

  void getFabVisibility(PortalUser? user) {
    if (user == null) return;

    if ((_projectDetailed?.security?['canEditTeam'] ?? false) ||
        (user.isAdmin ?? false) ||
        (user.isOwner ?? false) ||
        (user.listAdminModules != null && user.listAdminModules!.contains('projects')))
      fabIsVisible.value = true;
    else
      fabIsVisible.value = false;
  }
}
