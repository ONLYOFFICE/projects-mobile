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
import 'package:projects/data/services/project_service.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/internal/utils/debug_print.dart';

class ProjectsFilterController extends BaseFilterController {
  final ProjectService _api = locator<ProjectService>();
  final Storage _storage = locator<Storage>();

  final _sortController = Get.find<ProjectsSortController>();
  Function? applyFiltersDelegate;

  String? _teamMemberFilter = '';
  String? _projectManagerFilter = '';
  String? _otherFilter = '';
  String? _statusFilter = '';

  String? get projectManagerFilter => _projectManagerFilter;
  String? get teamMemberFilter => _teamMemberFilter;
  String? get otherFilter => _otherFilter;
  String? get statusFilter => _statusFilter;

  var _selfId;

  bool get _hasFilters =>
      _projectManagerFilter!.isNotEmpty ||
      _teamMemberFilter!.isNotEmpty ||
      _otherFilter!.isNotEmpty ||
      _statusFilter!.isNotEmpty;

  late RxMap<String, dynamic> projectManager;
  late RxMap<String, dynamic> teamMember;
  late RxMap<String, dynamic> other;
  late RxMap<String, dynamic> status;

  @override
  String get filtersTitle => plural('projectsFilterConfirm', suitableResultCount.value);

  ProjectsFilterController() {
    suitableResultCount = (-1).obs;
  }

  @override
  Future<void> restoreFilters() async {
    suitableResultCount.value = -1;
    hasFilters.value = _hasFilters;

    await _getSavedFilters();
  }

  @override
  void onInit() async {
    await loadFilters();
    super.onInit();
  }

  Future<void> changeProjectManager(String filter, [newValue = '']) async {
    _selfId = await Get.find<UserController>().getUserId();
    _projectManagerFilter = '';
    if (filter == 'me') {
      projectManager['other'] = '';
      projectManager['me'] = !(projectManager['me'] as bool);
      if (projectManager['me'] as bool) _projectManagerFilter = '&manager=$_selfId';
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
    await getSuitableResultCount();
  }

  Future<void> changeTeamMember(String filter, [newValue = '']) async {
    _selfId = await Get.find<UserController>().getUserId();
    _teamMemberFilter = '';
    if (filter == 'me') {
      teamMember['other'] = '';
      teamMember['me'] = !(teamMember['me'] as bool);
      if (teamMember['me'] as bool) _teamMemberFilter = '&participant=$_selfId';
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
    await getSuitableResultCount();
  }

  Future<void> changeOther(String filter, [newValue = '']) async {
    _otherFilter = '';
    switch (filter) {
      case 'followed':
        other['followed'] = !(other['followed'] as bool);
        other['withTag'] = '';
        other['withoutTag'] = false;

        if (other['followed'] as bool) _otherFilter = '&follow=true';
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
        other['withoutTag'] = !(other['withoutTag'] as bool);
        if (other['withoutTag'] as bool) _otherFilter = '&tag=-1';
        break;
      default:
    }
    await getSuitableResultCount();
  }

  void changeStatus(String filter, [newValue = '']) async {
    _statusFilter = '';
    switch (filter) {
      case 'active':
        status['active'] = !(status['active'] as bool);
        status['paused'] = false;
        status['closed'] = false;

        if (status['active'] as bool) _statusFilter = '&status=open';
        break;
      case 'paused':
        status['active'] = false;
        status['paused'] = !(status['paused'] as bool);
        status['closed'] = false;

        if (status['paused'] as bool) _statusFilter = '&status=paused';
        break;
      case 'closed':
        status['active'] = false;
        status['paused'] = false;
        status['closed'] = !(status['closed'] as bool);

        if (status['closed'] as bool) _statusFilter = '&status=closed';
        break;
      default:
    }
    await getSuitableResultCount();
  }

  @override
  Future<void> getSuitableResultCount() async {
    suitableResultCount.value = -1;
    hasFilters.value = _hasFilters;

    final result = await _api.getProjectsByParams(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectManagerFilter: projectManagerFilter,
      participantFilter: teamMemberFilter,
      otherFilter: otherFilter,
      statusFilter: statusFilter,
    );

    if (result != null) suitableResultCount.value = result.response!.length;
  }

  @override
  void resetFilters() async {
    projectManager['me'] = false;
    projectManager['other'] = '';

    teamMember['me'] = false;
    teamMember['other'] = '';

    other['followed'] = false;
    other['withTag'] = '';
    other['withoutTag'] = false;

    status['active'] = false;
    status['paused'] = false;
    status['closed'] = false;

    _projectManagerFilter = '';
    _teamMemberFilter = '';
    _otherFilter = '';
    _statusFilter = '';

    await getSuitableResultCount();
  }

  @override
  void applyFilters() async {
    hasFilters.value = _hasFilters;
    suitableResultCount.value = -1;

    applyFiltersDelegate?.call();

    await saveFilters();
  }

  Future<void> setupPreset(PresetProjectFilters? preset) async {
    _selfId = await Get.find<UserController>().getUserId();

    switch (preset) {
      case PresetProjectFilters.myProjects:
        _statusFilter = '&status=open';
        _teamMemberFilter = '&participant=$_selfId';
        break;
      case PresetProjectFilters.myFollowedProjects:
        _statusFilter = '&status=open';
        _otherFilter = '&follow=true';
        break;
      case PresetProjectFilters.active:
        _statusFilter = '&status=open';
        break;
      case PresetProjectFilters.saved:
        await _getSavedFilters();
        break;
      case PresetProjectFilters.myMembership:
        _statusFilter = '&status=open';
        _teamMemberFilter = '&participant=$_selfId';
        break;
      case PresetProjectFilters.myManaged:
        _statusFilter = '&status=open';
        _projectManagerFilter = '&manager=$_selfId';
        break;
      default:
    }

    hasFilters.value = _hasFilters;
  }

  @override
  Future<void> saveFilters() async {
    await _storage.write(
      'projectFilters',
      {
        'projectManager': {'buttons': Map.from(projectManager), 'value': _projectManagerFilter},
        'teamMember': {'buttons': Map.from(teamMember), 'value': _teamMemberFilter},
        'other': {'buttons': Map.from(other), 'value': _otherFilter},
        'status': {'buttons': Map.from(status), 'value': _statusFilter},
        'hasFilters': _hasFilters,
      },
    );
  }

  @override
  Future<void> loadFilters() async {
    projectManager = {'me': false, 'other': ''}.obs;
    teamMember = {'me': true, 'other': ''}.obs;
    other = {'followed': false, 'withTag': '', 'withoutTag': false}.obs;
    status = {'active': true, 'paused': false, 'closed': false}.obs;
  }

  Future<void> _getSavedFilters() async {
    final savedFilters = await _storage.read('projectFilters');

    if (savedFilters != null) {
      try {
        projectManager.value =
            Map<String, Object>.from(savedFilters['projectManager']['buttons'] as Map);
        _projectManagerFilter = savedFilters['projectManager']['value'] as String;

        teamMember.value = Map<String, Object>.from(savedFilters['teamMember']['buttons'] as Map);
        _teamMemberFilter = savedFilters['teamMember']['value'] as String;

        other.value = Map<String, Object>.from(savedFilters['other']['buttons'] as Map);
        _otherFilter = savedFilters['other']['value'] as String;

        status.value = Map<String, bool>.from(savedFilters['status']['buttons'] as Map);
        _statusFilter = savedFilters['status']['value'] as String;

        hasFilters.value = savedFilters['hasFilters'] as bool;
      } catch (e) {
        printWarning('Projects filter loading error: $e');
        await loadFilters();
      }
    } else {
      _statusFilter = '&status=open';
      _teamMemberFilter = '&participant=$_selfId';
    }
  }
}

enum PresetProjectFilters { active, myProjects, myFollowedProjects, saved, myMembership, myManaged }
