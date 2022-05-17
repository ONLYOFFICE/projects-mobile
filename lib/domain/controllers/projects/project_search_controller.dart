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

import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base/base_search_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class ProjectSearchController extends BaseSearchController {
  final _api = locator<ProjectService>();

  late String _selfId;
  final bool onlyMyProjects; // TODO not used

  final _paginationController = PaginationController<ProjectDetailed>();

  @override
  PaginationController get paginationController => _paginationController;

  RxList<ProjectDetailed> get itemList => _paginationController.data;

  final ProjectsSortController? sortController;
  final ProjectsFilterController? filterController;

  ProjectSearchController(
      {this.sortController, this.filterController, this.onlyMyProjects = false});

  String _query = '';
  String _searchQuery = '';

  Timer? _searchDebounce;

  StreamSubscription? _refreshProjectsSubscription;

  @override
  void onClose() {
    _refreshProjectsSubscription?.cancel();
    super.onClose();
  }

  @override
  Future<void> onInit() async {
    paginationController.startIndex = 0;
    _paginationController.loadDelegate = () async => await _performSearch(needToClear: false);
    _paginationController.refreshDelegate = () async => await refreshData();

    if (onlyMyProjects) {
      _selfId = (await Get.find<UserController>().getUserId())!;
      _searchQuery = '&participant=$_selfId';
    }

    _refreshProjectsSubscription = locator<EventHub>().on('needToRefreshProjects', (dynamic data) {
      if (data['all'] == true) {
        newSearch(_searchQuery);
        return;
      }
      if (data['projectDetails'].id != null) {
        final index = itemList.indexWhere((element) => element.id == data['projectDetails'].id);
        if (index != -1) {
          itemList[index] = data['projectDetails'] as ProjectDetailed;
          loaded.value = false;
          loaded.value = true;
        }
      }
    });

    loaded.value = true;

    super.onInit();
  }

  @override
  Future<void> refreshData() async {
    await _performSearch(needToClear: true);
  }

  void newSearch(String query, {bool needToClear = true}) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      _query = query.toLowerCase();

      if (_searchQuery != _query || _query == '') {
        _searchQuery = _query;

        if (onlyMyProjects) _searchQuery += '&participant=$_selfId';

        await _performSearch(needToClear: needToClear);
      }
    });
  }

  Future<void> _performSearch({bool needToClear = true}) async {
    if (needToClear) loaded.value = false;

    if (needToClear) paginationController.startIndex = 0;

    final result = await _api.getProjectsByParams(
      startIndex: paginationController.startIndex,
      sortBy: sortController?.currentSortfilter,
      sortOrder: sortController?.currentSortOrder,
      projectManagerFilter: filterController?.projectManagerFilter,
      participantFilter: filterController?.teamMemberFilter,
      otherFilter: filterController?.otherFilter,
      statusFilter: filterController?.statusFilter,
      query: _searchQuery.toLowerCase(),
    );

    if (result != null) {
      paginationController.total.value = result.total;

      if (needToClear) paginationController.data.clear();

      paginationController.data.addAll(result.response ?? <ProjectDetailed>[]);
    }
    if (needToClear) loaded.value = true;
  }

  @override
  void clearSearch() {
    _searchQuery = onlyMyProjects ? '&participant=$_selfId' : '';
    textController.clear();
    paginationController.clear();
  }

  @override
  Future<void> search(String? query, {bool needToClear = true}) async => newSearch(query ?? '');
}
