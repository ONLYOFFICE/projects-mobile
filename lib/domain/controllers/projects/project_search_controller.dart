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

import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectSearchController extends GetxController {
  static const PAGINATION_LENGTH = 25;

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
    _startIndex += PAGINATION_LENGTH;
    if (_startIndex >= _totalProjects) {
      refreshController.loadComplete();
      _startIndex -= PAGINATION_LENGTH;
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
