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
import 'package:event_hub/event_hub.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/services/task/task_service.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/base/base_task_filter_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/internal/locator.dart';

class TasksSearchController extends BaseController {
  final _api = locator<TaskService>();

  final nothingFound = false.obs;

  final _paginationController = PaginationController<PortalTask>();
  @override
  PaginationController<PortalTask> get paginationController => _paginationController;
  @override
  RxList get itemList => _paginationController.data;

  final searchInputController = TextEditingController();

  late String _query;

  String _searchQuery = '';
  Timer? _searchDebounce;

  final int? _projectId = Get.arguments['projectId'] as int?;
  final _filterController = Get.arguments['tasksFilterController'] as BaseTaskFilterController?;
  final _sortController = Get.arguments['tasksSortController'] as TasksSortController?;

  StreamSubscription? _refreshTasksSubscription;

  @override
  void onClose() {
    _refreshTasksSubscription?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    screenName = tr('tasksSearch');
    paginationController.startIndex = 0;
    _paginationController.loadDelegate = () => _performSearch(needToClear: false);
    paginationController.refreshDelegate = () => newSearch(_query);

    _refreshTasksSubscription = locator<EventHub>().on('needToRefreshTasks', (dynamic data) {
      if (data['all'] == true) {
        _performSearch();
        return;
      }
    });

    loaded.value = true;
    super.onInit();
  }

  void newSearch(String query, {bool needToClear = true}) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      _query = query.toLowerCase();
      if (_searchQuery != query) {
        _searchQuery = query;

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
    final result = await _api.getTasksByParams(
      startIndex: paginationController.startIndex,
      sortBy: _sortController?.currentSortfilter,
      sortOrder: _sortController?.currentSortOrder,
      responsibleFilter: _filterController?.responsibleFilter,
      creatorFilter: _filterController?.creatorFilter,
      projectFilter: _filterController?.projectFilter,
      milestoneFilter: _filterController?.milestoneFilter,
      deadlineFilter: _filterController?.deadlineFilter,
      query: _query.toLowerCase(),
      projectId: _projectId?.toString(),
    );

    if (result != null) {
      paginationController.total.value = result.total;

      if (result.response!.isEmpty) nothingFound.value = true;

      if (needToClear) paginationController.data.clear();

      paginationController.data.addAll(result.response ?? <PortalTask>[]);
    }
  }

  void clearSearch() {
    nothingFound.value = false;
    searchInputController.clear();
    paginationController.data.clear();
  }
}
