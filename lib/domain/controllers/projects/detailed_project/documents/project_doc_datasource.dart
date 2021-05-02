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
