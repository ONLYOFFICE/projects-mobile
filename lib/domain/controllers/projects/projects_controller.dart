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
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/from_api/project_tag.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/projects_view/new_project/new_project_view.dart';
import 'package:projects/presentation/views/projects_view/project_search_view.dart';

class ProjectsController extends BaseController {
  final _api = locator<ProjectService>();

  final tags = <ProjectTag>[].obs;

  final _paginationController = PaginationController<ProjectDetailed>();
  @override
  PaginationController<ProjectDetailed> get paginationController => _paginationController;

  @override
  RxList<ProjectDetailed> get itemList => _paginationController.data;

  PresetProjectFilters? _preset;

  final _sortController = Get.find<ProjectsSortController>();
  ProjectsSortController get sortController => _sortController;

  final _filterController = Get.find<ProjectsFilterController>();
  ProjectsFilterController get filterController => _filterController;

  final fabIsVisible = false.obs;

  var _withFAB = true;

  final _ss = <StreamSubscription>[];

  ProjectsController() {
    screenName = tr('projects');

    _sortController.updateSortDelegate = loadProjects;
    _filterController.applyFiltersDelegate = loadProjects;

    paginationController.loadDelegate = _getProjects;
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

    _ss.add(locator<EventHub>().on('needToRefreshProjects', (dynamic data) {
      if (data['all'] == true) {
        loadProjects();
        return;
      }

      if (data['projectDetails'].id != null) {
        for (var i = 0; i < itemList.length; i++)
          if (itemList[i].id == data['projectDetails'].id) {
            itemList[i] = data['projectDetails'] as ProjectDetailed;
            return;
          }
      }
    }));
  }

  @override
  void onClose() {
    for (final element in _ss) {
      element.cancel();
    }
    super.onClose();
  }

  @override
  void showSearch() {
    Get.find<NavigationController>().to(ProjectSearchView(),
        arguments: {'filtersController': _filterController, 'sortController': _sortController});
  }

  Future<void> refreshData() async {
    loaded.value = false;

    unawaited(Get.find<UserController>().updateData());
    await _getProjects(needToClear: true);

    loaded.value = true;
  }

  void setup(PresetProjectFilters preset, {bool withFAB = true}) {
    _preset = preset;
    _withFAB = withFAB;
  }

  Future<void> loadProjects() async {
    loaded.value = false;

    paginationController.startIndex = 0;
    if (_preset != null) await _filterController.setupPreset(_preset);

    await _getProjects(needToClear: true);

    loaded.value = true;
  }

  Future<void> _getProjects({bool needToClear = false}) async {
    final result = await _api.getProjectsByParams(
      startIndex: paginationController.startIndex,
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectManagerFilter: _filterController.projectManagerFilter,
      participantFilter: _filterController.teamMemberFilter,
      otherFilter: _filterController.otherFilter,
      statusFilter: _filterController.statusFilter,
    );
    if (result == null) return;

    if (needToClear) paginationController.data.clear();

    paginationController.total.value = result.total;
    paginationController.data.addAll(result.response ?? <ProjectDetailed>[]);

    expandedCardView.value = paginationController.data.isNotEmpty;
  }

  Future getProjectTags() async {
    loaded.value = false;

    final result = await _api.getProjectTags();
    if (result != null) {
      tags.value = result;
    }
    loaded.value = true;
  }

  void createNewProject() {
    Get.find<NavigationController>().toScreen(
      const NewProject(),
      transition: Transition.cupertinoDialog,
      fullscreenDialog: true,
      page: '/NewProject',
    );
  }

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
        (info.canCreateProject ?? false))
      fabIsVisible.value = true;
    else
      fabIsVisible.value = false;
  }
}
