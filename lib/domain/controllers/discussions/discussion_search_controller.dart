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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';

class DiscussionSearchController extends BaseController {
  final DiscussionsService _api = locator<DiscussionsService>();

  RxBool loaded = true.obs;
  RxBool nothingFound = false.obs;

  String? _query;

  final _paginationController = PaginationController<Discussion>();
  PaginationController<Discussion> get paginationController =>
      _paginationController;

  TextEditingController searchInputController = TextEditingController();

  @override
  RxList get itemList => _paginationController.data;

  @override
  void onInit() {
    screenName = tr('discussionsSearch');
    paginationController.startIndex = 0;
    _paginationController.loadDelegate =
        () => _performSearch(needToClear: false);
    paginationController.refreshDelegate = () => newSearch(_query!);
    super.onInit();
  }

  void newSearch(String query, {bool needToClear = true}) async {
    _query = query.toLowerCase();
    loaded.value = false;

    if (needToClear) paginationController.startIndex = 0;

    if (query == null || query.isEmpty) {
      clearSearch();
    } else {
      await _performSearch(needToClear: needToClear);
    }

    loaded.value = true;
  }

  Future<void> _performSearch({bool needToClear = true}) async {
    nothingFound.value = false;
    var result = await (_api.getDiscussionsByParams(
      startIndex: paginationController.startIndex,
      query: _query,
    ) as Future<PageDTO<List<Discussion>>>);

    paginationController.total.value = result.total!;

    if (result.response!.isEmpty) nothingFound.value = true;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response!);
  }

  void clearSearch() {
    nothingFound.value = false;
    searchInputController.clear();
    paginationController.data.clear();
  }
}
