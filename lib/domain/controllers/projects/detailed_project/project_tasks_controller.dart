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
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_tasks_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/base_task_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/task/task_service.dart';
import 'package:projects/presentation/views/tasks/tasks_search_screen.dart';

class ProjectTasksController extends BaseTasksController {
  final TaskService _api = locator<TaskService>();

  @override
  RxList<PortalTask> get itemList => _paginationController.data;
  @override
  PaginationController<PortalTask> get paginationController => _paginationController;
  final _paginationController = PaginationController<PortalTask>();

  @override
  TasksSortController get sortController => _sortController;
  final _sortController = Get.put(TasksSortController(), tag: 'ProjectTasksController');

  @override
  ProjectTaskFilterController get filterController => _filterController;
  final _filterController = Get.find<ProjectTaskFilterController>();

  @override
  RxBool get hasFilters => _filterController.hasFilters;

  ProjectDetailed get projectDetailed => _projectDetailed;
  ProjectDetailed _projectDetailed = ProjectDetailed();

  final fabIsVisible = false.obs;

  late StreamSubscription _refreshTasksSubscription;
  late StreamSubscription _refreshDetailsSubscription;

  ProjectTasksController() {
    _sortController.updateSortDelegate = () async => await loadTasks();
    _filterController.applyFiltersDelegate = () async => loadTasks();

    _paginationController.loadDelegate = () async => await _getTasks();
    _paginationController.refreshDelegate = () async => await loadTasks();
    _paginationController.pullDownEnabled = true;

    _refreshTasksSubscription = locator<EventHub>().on('needToRefreshTasks', (dynamic data) {
      if (data['all'] == true) {
        loadTasks();
        return;
      }

      if (data['task'].id != null) {
        for (var i = 0; i < itemList.length; i++)
          if (itemList[i].id == data['task'].id) {
            itemList[i] = data['task'] as PortalTask;
            return;
          }
      }
    });

    _refreshDetailsSubscription = locator<EventHub>().on('needToRefreshProjects', (dynamic data) {
      if (data['projectDetails'].id == _projectDetailed.id) {
        _projectDetailed = data['projectDetails'] as ProjectDetailed;
        fabIsVisible.value = _canCreate();
      }
    });
  }

  @override
  void onClose() {
    _refreshTasksSubscription.cancel();
    _refreshDetailsSubscription.cancel();
    super.dispose();
  }

  @override
  void showSearch() => Get.find<NavigationController>().to(const TasksSearchScreen(), arguments: {
        'projectId': projectDetailed.id,
        'tasksFilterController': filterController,
        'tasksSortController': sortController
      });

  Future<void> loadTasks() async {
    loaded.value = false;

    unawaited(updateDetails());
    await _getTasks(needToClear: true);

    loaded.value = true;
  }

  Future<bool> _getTasks({bool needToClear = false}) async {
    if (needToClear) _paginationController.clear();

    final result = await _api.getTasksByParams(
        startIndex: _paginationController.startIndex,
        sortBy: _sortController.currentSortfilter,
        sortOrder: _sortController.currentSortOrder,
        statusFilter: _filterController.statusFilter,
        responsibleFilter: _filterController.responsibleFilter,
        creatorFilter: _filterController.creatorFilter,
        projectFilter: _filterController.projectFilter,
        milestoneFilter: _filterController.milestoneFilter,
        deadlineFilter: _filterController.deadlineFilter,
        projectId: _projectDetailed.id.toString());

    if (result?.response == null) return false;

    _paginationController.total.value = result!.total;
    _paginationController.data.addAll(result.response!);

    return true;
  }

  void setup(ProjectDetailed projectDetailed) {
    loaded.value = false;

    _projectDetailed = projectDetailed;
    _filterController.projectId = projectDetailed.id.toString();
    fabIsVisible.value = _canCreate();

    loadTasks();
  }

  bool _canCreate() => _projectDetailed.security?['canCreateTask'] ?? false;

  Future<void> updateDetails() async {
    // TODO move to 'needToRefreshDetails' with id event

    final response =
        await locator<ProjectService>().getProjectById(projectId: _projectDetailed.id!);

    if (response == null) {
      if (!(await locator<AuthService>().checkAuthorization())) {
        await Get.find<ErrorDialog>().show(tr('selfUserNotFound'), awaited: true);

        await Get.find<LoginController>().logout();
      }

      return;
    }

    _projectDetailed = response;
    fabIsVisible.value = _canCreate();

    locator<EventHub>().fire('needToRefreshProjects', {'projectDetails': response});
  }
}
