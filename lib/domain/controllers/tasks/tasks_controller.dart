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
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/services/task/task_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/projects_with_presets.dart';
import 'package:projects/domain/controllers/tasks/base_task_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/tasks/task_statuses_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/tasks/tasks_search_screen.dart';

class TasksController extends BaseTasksController {
  final _api = locator<TaskService>();

  final projectsWithPresets = locator<ProjectsWithPresets>();
  PresetTaskFilters? _preset;

  @override
  PaginationController<PortalTask> get paginationController => _paginationController;
  final _paginationController = PaginationController<PortalTask>();
  @override
  RxList<PortalTask> get itemList => paginationController.data;

  @override
  TasksSortController get sortController => _sortController;
  final _sortController = TasksSortController();

  @override
  TaskFilterController get filterController => _filterController;
  final _filterController = TaskFilterController();

  @override
  RxBool get hasFilters => _filterController.hasFilters;

  final taskStatusesLoaded = false.obs;
  final fabIsVisible = false.obs;

  bool _withFAB = true;

  final _ss = <StreamSubscription>[];

  TasksController() {
    screenName = tr('tasks');

    _sortController.updateSortDelegate = loadTasks;
    _filterController.applyFiltersDelegate = loadTasks;

    paginationController.loadDelegate = _getTasks;
    paginationController.refreshDelegate = refreshData;
    paginationController.pullDownEnabled = true;

    if (_withFAB) {
      getFabVisibility(false);
      _ss.add(Get.find<UserController>().dataUpdated.listen(getFabVisibility));

      _ss.add(Get.find<NavigationController>().onMoreView.listen((moreOpen) {
        if (moreOpen) {
          fabIsVisible.value = false;
          return;
        }

        getFabVisibility(false);
      }));
    }

    Get.find<TaskStatusesController>()
        .getStatuses()
        .then((value) => taskStatusesLoaded.value = true);

    _ss.add(locator<EventHub>().on('needToRefreshTasks', (dynamic data) {
      refreshData();
    }));
  }

  @override
  void onClose() {
    for (final element in _ss) {
      element.cancel();
    }
    super.onClose();
  }

  Future<void> refreshData() async {
    loaded.value = false;

    unawaited(Get.find<UserController>().updateData());
    await _getTasks(needToClear: true);

    loaded.value = true;
  }

  void setup(PresetTaskFilters preset, {bool withFAB = true}) {
    _preset = preset;
    _withFAB = withFAB;
  }

  Future loadTasks() async {
    loaded.value = false;

    paginationController.startIndex = 0;
    if (_preset != null) await _filterController.setupPreset(_preset!);

    await _getTasks(needToClear: true);

    loaded.value = true;
  }

  Future<bool> _getTasks({bool needToClear = false}) async {
    final result = await _api.getTasksByParams(
      startIndex: paginationController.startIndex,
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      responsibleFilter: _filterController.responsibleFilter,
      creatorFilter: _filterController.creatorFilter,
      projectFilter: _filterController.projectFilter,
      milestoneFilter: _filterController.milestoneFilter,
      statusFilter: _filterController.statusFilter,
      deadlineFilter: _filterController.deadlineFilter,
      // query: 'задача',
    );

    if (result == null) return Future.value(false);

    if (needToClear) paginationController.data.clear();

    paginationController.total.value = result.total;
    if (result.total != 0) paginationController.data.addAll(result.response ?? <PortalTask>[]);

    expandedCardView.value = paginationController.data.isNotEmpty;

    return Future.value(true);
  }

  @override
  void showSearch() => Get.find<NavigationController>().to(const TasksSearchScreen(), arguments: {
        'tasksFilterController': filterController,
        'tasksSortController': sortController
      });

  void getFabVisibility(bool _) {
    if (Get.find<NavigationController>().onMoreView.value) {
      fabIsVisible.value = false;
      return;
    }

    final user = Get.find<UserController>().user.value;
    final info = Get.find<UserController>().securityInfo.value;

    if (user == null || info == null) return;

    if ((user.isAdmin ?? false) ||
        (user.isOwner ?? false) ||
        (user.listAdminModules != null && user.listAdminModules!.contains('projects')) ||
        (info.canCreateTask ?? false))
      fabIsVisible.value = true;
    else
      fabIsVisible.value = false;
  }
}
