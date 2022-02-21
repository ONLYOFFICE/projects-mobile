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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_filter_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_sort_controller.dart';
import 'package:projects/internal/locator.dart';

class MilestonesDataSource extends BaseController {
  final MilestoneService _api = locator<MilestoneService>();

  int get itemCount => _paginationController.data.length;
  @override
  RxList<Milestone> get itemList => _paginationController.data;
  @override
  PaginationController get paginationController => _paginationController;
  final _paginationController = PaginationController<Milestone>();

  MilestonesSortController get sortController => _sortController;
  final _sortController = Get.find<MilestonesSortController>();

  MilestonesFilterController get filterController => _filterController;
  final _filterController = Get.find<MilestonesFilterController>();

  final searchTextEditingController = TextEditingController();

  String searchQuery = '';

  Timer? _searchDebounce;

  ProjectDetailed get projectDetailed => _projectDetailed ?? ProjectDetailed();
  ProjectDetailed? _projectDetailed;

  int? _projectId;

  final fabIsVisible = false.obs;

  late StreamSubscription _refreshMilestonesSubscription;

  MilestonesDataSource() {
    _sortController.updateSortDelegate = () async => loadMilestones();
    _filterController.applyFiltersDelegate = () async => loadMilestones();
    _paginationController.loadDelegate = () async => _getMilestones();
    _paginationController.refreshDelegate = () async => loadMilestones();
    _paginationController.pullDownEnabled = true;

    _refreshMilestonesSubscription =
        locator<EventHub>().on('needToRefreshMilestones', (dynamic data) {
      loadMilestones();
    });
  }

  @override
  void onClose() {
    _refreshMilestonesSubscription.cancel();
    searchTextEditingController.dispose();
    super.onClose();
  }

  Future loadMilestones() async {
    loaded.value = false;

    _paginationController.startIndex = 0;
    await _getMilestones(needToClear: true);

    loaded.value = true;
  }

  Future<bool> _getMilestones({bool needToClear = false}) async {
    final result = await _api.milestonesByFilter(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectId: _projectId?.toString(),
      milestoneResponsibleFilter: _filterController.milestoneResponsibleFilter,
      taskResponsibleFilter: _filterController.taskResponsibleFilter,
      statusFilter: _filterController.statusFilter,
      deadlineFilter: _filterController.deadlineFilter,
      query: searchQuery,
    );
    if (result == null) return Future.value(false);

    _paginationController.total.value = result.length;
    if (needToClear) _paginationController.data.clear();
    _paginationController.data.addAll(result);

    return Future.value(true);
  }

  void setup({ProjectDetailed? projectDetailed, int? projectId}) {
    loaded.value = false;

    _projectDetailed = projectDetailed;
    _projectId = projectId ?? projectDetailed!.id;
    _filterController.projectId = _projectId.toString();
    fabIsVisible.value = _canCreate();

    loadMilestones();
  }

  bool _canCreate() => _projectDetailed?.security?['canCreateMilestone'] ?? false;

  void loadMilestonesWithFilterByName(String searchText) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      if (searchQuery != searchText) {
        searchQuery = searchText;
        await loadMilestones();
      }
    });
  }

  void clearSearchAndReloadMilestones() {
    searchTextEditingController.clear();
    searchQuery = '';
    loadMilestones();
  }
}
