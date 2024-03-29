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

import 'package:get/get.dart';
import 'package:projects/data/services/group_service.dart';
import 'package:projects/domain/controllers/base/base_search_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';

// currently not used. There is no way to search for groups using the api
class GroupSearchController extends BaseSearchController {
  final GroupService _service = locator<GroupService>();

  final _paginationController = Get.put(PaginationController(), tag: 'GroupSearchController');

  @override
  PaginationController get paginationController => _paginationController;

  String? _query;

  @override
  void onInit() {
    paginationController.startIndex = 0;

    paginationController.loadDelegate =
        () async => await _performSearch(query: _query, needToClear: false);

    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;
    super.onInit();
  }

  @override
  Future search(String? query, {bool needToClear = true}) async {
    paginationController.startIndex = 0;
    loaded.value = false;
    _query = query;
    await _performSearch(query: query, needToClear: needToClear);
    loaded.value = true;
  }

  @override
  Future<void> refreshData() async {
    loaded.value = false;
    await _performSearch(needToClear: true, query: _query);
    loaded.value = true;
  }

  Future _performSearch({bool needToClear = true, String? query}) async {
    // now the result is incorrect
    final result = await _service.getGroupsByExtendedFilter(
      startIndex: paginationController.startIndex,
      query: query,
    );

    addData(result, needToClear);
  }

  void clear() {
    paginationController.data.clear();
    _query = null;
  }
}
