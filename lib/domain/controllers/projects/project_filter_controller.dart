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

import 'package:get/get.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class ProjectsFilterController extends BaseFilterController {
  final _api = locator<ProjectService>();

  final _sortController = Get.find<TasksSortController>();
  Function applyFiltersDelegate;

  String _teamMemberFilter = '';
  String _projectManagerFilter = '';
  String _otherFilter = '';
  String _statusFilter = '';

  String get projectManagerFilter => _projectManagerFilter;
  String get teamMemberFilter => _teamMemberFilter;
  String get otherFilter => _otherFilter;
  String get statusFilter => _statusFilter;

  var _selfId;

  @override
  bool get hasFilters =>
      _projectManagerFilter.isNotEmpty ||
      _teamMemberFilter.isNotEmpty ||
      _otherFilter.isNotEmpty ||
      _statusFilter.isNotEmpty;

  RxMap<String, dynamic> projectManager = {'me': false, 'other': ''}.obs;
  RxMap<String, dynamic> teamMember = {'me': false, 'other': ''}.obs;

  RxMap<String, dynamic> other =
      {'followed': false, 'withTag': '', 'withoutTag': false}.obs;

  RxMap<String, dynamic> status =
      {'active': false, 'paused': false, 'closed': false}.obs;

  ProjectsFilterController() {
    filtersTitle = 'PROJECTS';
    suitableTasksCount = (-1).obs;
  }

  Future<void> changeProjectManager(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _projectManagerFilter = '';
    if (filter == 'me') {
      projectManager['other'] = '';
      projectManager['me'] = !projectManager['me'];
      if (projectManager['me']) _projectManagerFilter = '&manager=$_selfId';
    }
    if (filter == 'other') {
      projectManager['me'] = false;
      if (newValue == null) {
        projectManager['other'] = '';
      } else {
        projectManager['other'] = newValue['displayName'];
        _projectManagerFilter = '&manager=${newValue["id"]}';
      }
    }
    getSuitableTasksCount();
  }

  Future<void> changeTeamMember(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _teamMemberFilter = '';
    if (filter == 'me') {
      teamMember['other'] = '';
      teamMember['me'] = !teamMember['me'];
      if (teamMember['me']) _teamMemberFilter = '&participant=$_selfId';
    }
    if (filter == 'other') {
      teamMember['me'] = false;
      if (newValue == null) {
        teamMember['other'] = '';
      } else {
        teamMember['other'] = newValue['displayName'];
        _teamMemberFilter = '&participant=${newValue["id"]}';
      }
    }
    getSuitableTasksCount();
  }

  void changeOther(String filter, [newValue = '']) async {
    _otherFilter = '';
    switch (filter) {
      case 'followed':
        other['followed'] = !other['followed'];
        other['withTag'] = '';
        other['withoutTag'] = false;

        if (other['followed']) _otherFilter = '&follow=true';
        break;
      case 'withTag':
        other['followed'] = false;
        other['withoutTag'] = false;
        if (newValue == null) {
          other['withTag'] = '';
        } else {
          other['withTag'] = newValue['title'];
          _otherFilter = '&tag=${newValue["id"]}';
        }
        break;
      case 'withoutTag':
        other['followed'] = false;
        other['withTag'] = '';
        other['withoutTag'] = !other['withoutTag'];
        if (other['withoutTag']) _otherFilter = '&tag=-1';
        break;
      default:
    }
    getSuitableTasksCount();
  }

  void changeStatus(String filter, [newValue = '']) async {
    _statusFilter = '';
    switch (filter) {
      case 'active':
        status['active'] = !status['active'];
        status['paused'] = false;
        status['closed'] = false;

        if (status['active']) _statusFilter = '&status=open';
        break;
      case 'paused':
        status['active'] = false;
        status['paused'] = !status['paused'];
        status['closed'] = false;

        if (status['paused']) _statusFilter = '&status=paused';
        break;
      case 'closed':
        status['active'] = false;
        status['paused'] = false;
        status['closed'] = !status['closed'];

        if (status['closed']) _statusFilter = '&status=closed';
        break;
      default:
    }
    getSuitableTasksCount();
  }

  void getSuitableTasksCount() async {
    suitableTasksCount.value = -1;

    var result = await _api.getProjectsByParams(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectManagerFilter: projectManagerFilter,
      participantFilter: teamMemberFilter,
      otherFilter: otherFilter,
      statusFilter: statusFilter,
    );

    suitableTasksCount.value = result.response.length;
  }

  @override
  void resetFilters() async {
    projectManager = {'me': false, 'other': ''}.obs;
    teamMember = {'me': false, 'other': ''}.obs;
    other = {'followed': false, 'withTag': '', 'withoutTag': false}.obs;
    status = {'active': false, 'paused': false, 'closed': false}.obs;

    suitableTasksCount.value = -1;

    _projectManagerFilter = '';
    _teamMemberFilter = '';
    _otherFilter = '';
    _statusFilter = '';

    applyFilters();
  }

  @override
  void applyFilters() async {
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }
}
