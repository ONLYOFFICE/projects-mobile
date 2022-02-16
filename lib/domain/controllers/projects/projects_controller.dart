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

  late final PaginationController<ProjectDetailed> _paginationController;
  @override
  PaginationController<ProjectDetailed> get paginationController => _paginationController;

  @override
  RxList get itemList => _paginationController.data;

  PresetProjectFilters? _preset;

  final _sortController = Get.find<ProjectsSortController>();
  ProjectsSortController get sortController => _sortController;

  late final ProjectsFilterController _filterController;
  ProjectsFilterController get filterController => _filterController;

  final _userController = Get.find<UserController>();

  final fabIsVisible = false.obs;

  var _withFAB = true;

  StreamSubscription? fabSubscription;
  late StreamSubscription _refreshProjectsSubscription;

  ProjectsController(
    ProjectsFilterController filterController,
    PaginationController<ProjectDetailed> paginationController,
  ) {
    screenName = tr('projects');
    _paginationController = paginationController;
    _sortController.updateSortDelegate = updateSort;
    _filterController = filterController;
    _filterController.applyFiltersDelegate = () async => await loadProjects();

    paginationController.loadDelegate = () async => await _getProjects();
    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;

    _refreshProjectsSubscription = locator<EventHub>().on('needToRefreshProjects', (dynamic data) {
      if (data.any((elem) => elem == 'all') as bool) {
        loadProjects();
        return;
      }
    });

    _userController.loaded.listen((_loaded) async =>
        {if (_loaded && _withFAB) fabIsVisible.value = await getFabVisibility()});

    getFabVisibility().then((visibility) => fabIsVisible.value = visibility);
    fabSubscription ??= locator<EventHub>().on('moreViewVisibilityChanged', (dynamic data) async {
      fabIsVisible.value = data as bool ? false : await getFabVisibility();
    });
  }

  @override
  void onClose() {
    fabSubscription?.cancel();
    _refreshProjectsSubscription.cancel();
    super.onClose();
  }

  Future<bool> getFabVisibility() async {
    if (!_withFAB) return false;
    await _userController.getUserInfo();
    await _userController.getSecurityInfo();
    if (_userController.user == null) return Future.value(false);
    return _userController.user!.isAdmin! ||
        _userController.user!.isOwner! ||
        (_userController.user!.listAdminModules != null &&
            _userController.user!.listAdminModules!.contains('projects')) ||
        _userController.securityInfo!.canCreateProject!;
  }

  @override
  void showSearch() {
    Get.find<NavigationController>().to(ProjectSearchView(),
        arguments: {'filtersController': filterController, 'sortController': sortController});
  }

  void updateSort() {
    loadProjects();
  }

  Future<void> refreshData() async {
    loaded.value = false;
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
    if (_preset != null) {
      await _filterController.setupPreset(_preset).then((value) => _getProjects(needToClear: true));
    } else {
      await _getProjects(needToClear: true);
    }
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
    if (needToClear) paginationController.data.clear();
    if (result == null) return;

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
    Get.find<NavigationController>()
        .to(const NewProject(), transition: Transition.cupertinoDialog, fullscreenDialog: true);
  }
}
