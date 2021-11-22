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
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/projects_with_presets.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/tasks/task_statuses_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/task/task_service.dart';
import 'package:projects/presentation/views/tasks/tasks_search_screen.dart';

class TasksController extends BaseController {
  final TaskService? _api = locator<TaskService>();

  final ProjectsWithPresets? projectsWithPresets = locator<ProjectsWithPresets>();

  PaginationController? _paginationController;

  final _userController = Get.find<UserController>();

  PresetTaskFilters? _preset;
  PaginationController? get paginationController => _paginationController;

  final taskStatusesController = Get.find<TaskStatusesController>();
  final _sortController = Get.find<TasksSortController>();
  final loaded = false.obs;
  final taskStatusesLoaded = false.obs;
  TasksSortController get sortController => _sortController;

  TaskFilterController? _filterController;
  TaskFilterController? get filterController => _filterController;

  var fabIsVisible = false.obs;
  var _withFAB = true;

  @override
  Future<void> onInit() async {
    await taskStatusesController
        .getStatuses()
        .then((value) => taskStatusesLoaded.value = true);
    super.onInit();
  }

  TasksController(TaskFilterController filterController,
      PaginationController paginationController) {
    loaded.value = false;
    screenName = tr('tasks');
    _paginationController = paginationController;
    expandedCardView.value = true;
    _filterController = filterController;
    _filterController!.applyFiltersDelegate = () async => loadTasks();
    _sortController.updateSortDelegate = () async => await loadTasks();
    paginationController.loadDelegate = () async => await _getTasks();
    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;

    getFabVisibility().then((value) => fabIsVisible.value = value);

    _userController.loaded.listen((_loaded) async => {
          if (_loaded && _withFAB) fabIsVisible.value = await getFabVisibility()
        });

    locator<EventHub>().on('moreViewVisibilityChanged', (dynamic data) async {
      fabIsVisible.value = data ? false : await getFabVisibility();
    });

    locator<EventHub>().on('needToRefreshTasks', (dynamic data) {
      refreshData();
    });

    loaded.value = true;
  }

  @override
  RxList get itemList => paginationController!.data;

  Future<void> refreshData() async {
    loaded.value = false;
    await _getTasks(needToClear: true);
    loaded.value = true;
  }

  void setup(PresetTaskFilters preset, {withFAB = true}) {
    _preset = preset;
    _withFAB = withFAB;
  }

  Future loadTasks() async {
    loaded.value = false;
    paginationController!.startIndex = 0;
    if (_preset != null) {
      await _filterController!
          .setupPreset(_preset!)
          .then((value) => _getTasks(needToClear: true));
    } else {
      await _getTasks(needToClear: true);
    }
    loaded.value = true;
  }

  Future _getTasks({needToClear = false}) async {
    var result = await (_api!.getTasksByParams(
      startIndex: paginationController!.startIndex,
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      responsibleFilter: _filterController!.responsibleFilter,
      creatorFilter: _filterController!.creatorFilter,
      projectFilter: _filterController!.projectFilter,
      milestoneFilter: _filterController!.milestoneFilter,
      statusFilter: _filterController!.statusFilter,
      deadlineFilter: _filterController!.deadlineFilter,
      // query: 'задача',
    ) as Future<PageDTO<List<PortalTask>>>);
    paginationController!.total.value = result.total!;

    if (needToClear) paginationController!.data.clear();

    paginationController!.data.addAll(result.response!);
    expandedCardView.value = paginationController!.data.isNotEmpty;
  }

  @override
  void showSearch() =>
      Get.find<NavigationController>().to(const TasksSearchScreen());

  Future<bool> getFabVisibility() async {
    if (!_withFAB) return false;
    var fabVisibility = false;
    await _userController.getUserInfo();
    var selfUser = _userController.user!;
    if (selfUser.isAdmin! ||
        selfUser.isOwner! ||
        (selfUser.listAdminModules != null &&
            selfUser.listAdminModules!.contains('projects'))) {
      if (projectsWithPresets!.activeProjectsController!.itemList.isEmpty)
        await projectsWithPresets!.activeProjectsController!.loadProjects();
      fabVisibility =
          projectsWithPresets!.activeProjectsController!.itemList.isNotEmpty;
    } else {
      if (projectsWithPresets!.myProjectsController!.itemList.isEmpty)
        await projectsWithPresets!.myProjectsController!.loadProjects();
      fabVisibility =
          projectsWithPresets!.myProjectsController!.itemList.isNotEmpty;
    }
    if (selfUser.isVisitor!) fabVisibility = false;

    return fabVisibility;
  }
}
