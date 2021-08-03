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
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/data/models/from_api/project_tag.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/presentation/views/projects_view/new_project/new_project_view.dart';
import 'package:projects/presentation/views/projects_view/project_search_view.dart';

class ProjectsController extends BaseController {
  final _api = locator<ProjectService>();

  var loaded = false.obs;

  RxList<ProjectTag> tags = <ProjectTag>[].obs;

  PaginationController _paginationController;
  PaginationController get paginationController => _paginationController;

  @override
  String get screenName => tr('projects');

  @override
  RxList get itemList => _paginationController.data;

  final _sortController = Get.find<ProjectsSortController>();
  ProjectsSortController get sortController => _sortController;

  ProjectsFilterController _filterController;
  ProjectsFilterController get filterController => _filterController;

  final _userController = Get.find<UserController>();

  bool fabIsVisible() {
    if (_userController.user == null) return false;

    return _userController.user.isAdmin || _userController.user.isOwner;
  }

  ProjectsController(
    ProjectsFilterController filterController,
    PaginationController paginationController,
  ) {
    _paginationController = paginationController;
    _sortController.updateSortDelegate = updateSort;
    _filterController = filterController;
    _filterController.applyFiltersDelegate =
        () async => await _getProjects(needToClear: true);

    paginationController.loadDelegate = () async => await _getProjects();
    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;

    _userController.getUserInfo();
  }

  @override
  void showSearch() {
    Get.find<NavigationController>().navigateToFullscreen(ProjectSearchView());
  }

  void updateSort() {
    loadProjects();
  }

  Future<void> refreshData() async {
    await _getProjects(needToClear: true);
  }

  Future<void> loadProjects() async {
    loaded.value = false;
    paginationController.startIndex = 0;
    await _getProjects(needToClear: true);
    loaded.value = true;
  }

  Future _getProjects({needToClear = false}) async {
    var result = await _api.getProjectsByParams(
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
    paginationController.data.addAll(result.response);
    expandedCardView.value = paginationController.data.isNotEmpty;
  }

  Future getProjectTags() async {
    loaded.value = false;
    tags.value = await _api.getProjectTags();
    loaded.value = true;
  }

  void createNewProject() {
    Get.find<NavigationController>().navigateToFullscreen(const NewProject());
  }
}
