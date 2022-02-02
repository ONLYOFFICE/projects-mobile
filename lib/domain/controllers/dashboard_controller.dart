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
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/projects/projects_with_presets.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_with_presets.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DashboardController extends GetxController {
  RefreshController _refreshController = RefreshController();

  RefreshController get refreshController {
    if (!_refreshController.isLoading && !_refreshController.isRefresh)
      _refreshController = RefreshController();
    return _refreshController;
  }

  final ProjectsWithPresets projectsWithPresets = locator<ProjectsWithPresets>();
  final TasksWithPresets tasksWithPresets = locator<TasksWithPresets>();

  final screenName = tr('dashboard');

  late TasksController _myTaskController;

  TasksController get myTaskController => _myTaskController;

  late TasksController _upcomingTaskscontroller;

  TasksController get upcomingTaskscontroller => _upcomingTaskscontroller;

  late ProjectsController _myProjectsController;

  ProjectsController get myProjectsController => _myProjectsController;

  late ProjectsController _folowedProjectsController;
  ProjectsController get folowedProjectsController => _folowedProjectsController;

  late ProjectsController _activeProjectsController;
  ProjectsController get activeProjectsController => _activeProjectsController;

  var scrollController = ScrollController();

  void setup() {
    _myTaskController = tasksWithPresets.myTasksController;
    _upcomingTaskscontroller = tasksWithPresets.upcomingTasksController;

    _myProjectsController = projectsWithPresets.myProjectsController;
    _folowedProjectsController = projectsWithPresets.folowedProjectsController;
    _activeProjectsController = projectsWithPresets.activeProjectsController;

    _myTaskController.screenName = tr('myTasks');
    _upcomingTaskscontroller.screenName = tr('upcomingTasks');
    _myProjectsController.screenName = tr('myProjects');
    _folowedProjectsController.screenName = tr('projectsIFolow');
    _activeProjectsController.screenName = tr('activeProjects');
  }

  void onRefresh() {
    refreshData();
    refreshProjectsData();

    // update the user data in case of changing user rights on the server side
    Get.find<UserController>()
      ..clear()
      // ignore: unawaited_futures
      ..getUserInfo()
      // ignore: unawaited_futures
      ..getSecurityInfo();

    _refreshController.refreshCompleted();
  }

  void onLoading() {
    loadContent();
    _refreshController.loadComplete();
  }

  void loadContent() {
    _myTaskController.loadTasks();
    _upcomingTaskscontroller.loadTasks();
    _myProjectsController.loadProjects();
    _folowedProjectsController.loadProjects();
    _activeProjectsController.loadProjects();
  }

  void refreshData() {
    _myTaskController.refreshData();
    _upcomingTaskscontroller.refreshData();
  }

  void refreshProjectsData() {
    _myProjectsController.refreshData();
    _folowedProjectsController.refreshData();
    _activeProjectsController.refreshData();
  }
}
