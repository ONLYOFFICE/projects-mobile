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
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_filter_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_sort_controller.dart';
import 'package:projects/internal/locator.dart';

class MilestonesDataSource extends GetxController {
  final MilestoneService _api = locator<MilestoneService>();

  final paginationController =
      Get.put(PaginationController<Milestone>(), tag: 'MilestonesDataSource');

  final _sortController = Get.find<MilestonesSortController>();
  final _filterController = Get.find<MilestonesFilterController>();

  final searchTextEditingController = TextEditingController();

  String searchQuery = '';

  Timer? _searchDebounce;

  ProjectDetailed? _projectDetailed;

  MilestonesSortController get sortController => _sortController;
  MilestonesFilterController get filterController => _filterController;

  int get itemCount => paginationController.data.length;
  RxList<Milestone> get itemList => paginationController.data;

  RxBool loaded = false.obs;

  RxBool hasFilters = false.obs;

  int? _projectId;

  RxBool fabIsVisible = false.obs;

  MilestonesDataSource() {
    _sortController.updateSortDelegate = () async => loadMilestones();
    _filterController.applyFiltersDelegate = () async => loadMilestones();
    paginationController.loadDelegate = () async => _getMilestones();
    paginationController.refreshDelegate = () async => loadMilestones();
    paginationController.pullDownEnabled = true;
  }

  Future loadMilestones() async {
    loaded.value = false;

    paginationController.startIndex = 0;
    await _getMilestones(needToClear: true);
    locator<EventHub>().fire('needToRefreshMilestones', ['all']);

    loaded.value = true;
  }

  Future<bool> _getMilestones({bool needToClear = false}) async {
    final result = await _api.milestonesByFilter(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectId: _projectId?.toString(),
      milestoneResponsibleFilter: _filterController.milestoneResponsibleFilter,
      taskResponsibleFilter: _filterController.taskResponsibleFilter,
      statusFilter: '&status=open',
      deadlineFilter: _filterController.deadlineFilter,
      query: searchQuery,
    );
    if (result == null) return Future.value(false);

    paginationController.total.value = result.length;
    if (needToClear) paginationController.data.clear();
    paginationController.data.addAll(result);

    return Future.value(true);
  }

  Future<void> setup({ProjectDetailed? projectDetailed, int? projectId}) async {
    loaded.value = false;
    _projectDetailed = projectDetailed;
    _projectId = projectId ?? projectDetailed!.id;
    _filterController.projectId = _projectId.toString();

    // ignore: unawaited_futures
    loadMilestones();

    fabIsVisible.value = _canCreate()!;
  }

  bool? _canCreate() =>
      _projectDetailed == null ? false : _projectDetailed!.security!['canCreateMilestone'] as bool;

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

  @override
  void onClose() {
    searchTextEditingController.dispose();
    super.onClose();
  }
}
