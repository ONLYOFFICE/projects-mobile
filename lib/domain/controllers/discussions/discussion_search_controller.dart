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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/base/base_sort_controller.dart';
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/domain/controllers/discussions/base_discussions_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_filter_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_sort_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';

class DiscussionSearchController extends BaseDiscussionsController {
  final _api = locator<DiscussionsService>();

  final nothingFound = false.obs;

  final _paginationController = PaginationController<Discussion>();
  @override
  PaginationController<Discussion> get paginationController => _paginationController;
  @override
  RxList get itemList => _paginationController.data;

  String? _query;
  String? _searchQuery;
  Timer? _searchDebounce;

  @override
  BaseFilterController get filterController => _filterController!;
  @override
  BaseSortController get sortController => _sortController!;

  final int? _projectId = Get.arguments['projectId'] as int?;
  final DiscussionsFilterController? _filterController =
      Get.arguments['discussionsFilterController'] as DiscussionsFilterController?;
  final DiscussionsSortController? _sortController =
      Get.arguments['discussionsSortController'] as DiscussionsSortController?;

  final searchInputController = TextEditingController();

  @override
  void onInit() {
    screenName = tr('discussionsSearch');
    paginationController.startIndex = 0;
    _paginationController.loadDelegate = () => _performSearch(needToClear: false);
    paginationController.refreshDelegate = () => newSearch(_query!);

    loaded.value = true;
    super.onInit();
  }

  void newSearch(String query, {bool needToClear = true}) async {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      _query = query.toLowerCase();

      if (_searchQuery != _query) {
        _searchQuery = _query;
        loaded.value = false;

        if (needToClear) paginationController.startIndex = 0;

        if (query.isEmpty) {
          clearSearch();
        } else {
          await _performSearch(needToClear: needToClear);
        }

        loaded.value = true;
      }
    });
  }

  Future<void> _performSearch({bool needToClear = true}) async {
    nothingFound.value = false;
    final result = await _api.getDiscussionsByParams(
      startIndex: paginationController.startIndex,
      sortBy: _sortController?.currentSortfilter,
      sortOrder: _sortController?.currentSortOrder,
      authorFilter: _filterController?.authorFilter,
      statusFilter: _filterController?.statusFilter,
      creationDateFilter: _filterController?.creationDateFilter,
      projectFilter: _filterController?.projectFilter,
      otherFilter: _filterController?.otherFilter,
      projectId: _projectId?.toString(),
      query: _query,
    );

    if (result != null) {
      paginationController.total.value = result.total;

      if (result.response!.isEmpty) nothingFound.value = true;

      if (needToClear) paginationController.data.clear();

      paginationController.data.addAll(result.response ?? <Discussion>[]);
    }
  }

  void clearSearch() {
    nothingFound.value = false;
    searchInputController.clear();
    paginationController.data.clear();
  }
}
