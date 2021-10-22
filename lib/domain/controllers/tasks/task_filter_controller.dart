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
import 'package:intl/intl.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/data/services/task/task_service.dart';
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class TaskFilterController extends BaseFilterController {
  final _api = locator<TaskService>();
  final _sortController = Get.find<TasksSortController>();
  final _storage = locator<Storage>();

  final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.mmm');

  Function applyFiltersDelegate;

  RxString acceptedFilters = ''.obs;

  String _responsibleFilter = '';
  String _creatorFilter = '';
  String _projectFilter = '';
  String _milestoneFilter = '';
  String _statusFilter = '';
  String _deadlineFilter = '';

  String get responsibleFilter => _responsibleFilter;
  String get creatorFilter => _creatorFilter;
  String get projectFilter => _projectFilter;
  String get milestoneFilter => _milestoneFilter;
  String get statusFilter => _statusFilter;
  String get deadlineFilter => _deadlineFilter;

  var _selfId;
  String _projectId;

  bool get _hasFilters =>
      _responsibleFilter.isNotEmpty ||
      _creatorFilter.isNotEmpty ||
      _projectFilter.isNotEmpty ||
      _deadlineFilter.isNotEmpty ||
      _milestoneFilter.isNotEmpty ||
      _statusFilter.isNotEmpty;

  RxMap responsible;

  RxMap creator;

  RxMap project;

  RxMap milestone;

  RxMap status;

  RxMap deadline;

  @override
  void onInit() async {
    // await _storage.removeAll();
    await loadFilters();
    super.onInit();
  }

  @override
  Future<void> restoreFilters() async => await _getSavedFilters();

  @override
  String get filtersTitle =>
      plural('tasksFilterConfirm', suitableResultCount.value);

  TaskFilterController() {
    suitableResultCount = (-1).obs;
  }

  set projectId(String value) => _projectId = value;

  void changeResponsible(String filter, [newValue = '']) async {
    _selfId = await Get.find<UserController>().getUserId();
    _responsibleFilter = '';

    switch (filter) {
      case 'me':
        responsible['other'] = '';
        responsible['groups'] = '';
        responsible['no'] = false;
        responsible['me'] = !responsible['me'];
        if (responsible['me']) _responsibleFilter = '&participant=$_selfId';
        break;
      case 'other':
        responsible['me'] = false;
        responsible['groups'] = '';
        responsible['no'] = false;
        if (newValue == null) {
          responsible['other'] = '';
        } else {
          responsible['other'] = newValue['displayName'];
          _responsibleFilter = '&participant=${newValue["id"]}';
        }
        break;
      case 'groups':
        responsible['me'] = false;
        responsible['other'] = '';
        responsible['no'] = false;
        if (newValue == null) {
          responsible['groups'] = '';
        } else {
          responsible['groups'] = newValue['name'];
          _responsibleFilter = '&departament=${newValue["id"]}';
        }
        break;
      case 'no':
        responsible['me'] = false;
        responsible['other'] = '';
        responsible['groups'] = '';
        responsible['no'] = !responsible['no'];
        if (responsible['no']) {
          _responsibleFilter =
              '&participant=00000000-0000-0000-0000-000000000000';
        }
        break;
      default:
    }
    getSuitableResultCount();
  }

  Future<void> changeCreator(String filter, [newValue = '']) async {
    _selfId = await Get.find<UserController>().getUserId();
    _creatorFilter = '';
    if (filter == 'me') {
      creator['other'] = '';
      creator['me'] = !creator['me'];
      if (creator['me']) _creatorFilter = '&creator=$_selfId';
    }
    if (filter == 'other') {
      creator['me'] = false;
      if (newValue == null) {
        creator['other'] = '';
      } else {
        creator['other'] = newValue['displayName'];
        _creatorFilter = '&creator=${newValue["id"]}';
      }
    }
    getSuitableResultCount();
  }

  void changeProject(String filter, [newValue = '']) async {
    _projectFilter = '';
    switch (filter) {
      case 'my':
        project['other'] = '';
        project['withTag'] = '';
        project['withoutTag'] = false;
        project['my'] = !project['my'];
        if (project['my']) _projectFilter = '&myprojects=true';
        break;
      case 'other':
        project['my'] = false;
        project['withTag'] = '';
        project['withoutTag'] = false;
        if (newValue == null) {
          project['other'] = '';
        } else {
          project['other'] = newValue['title'];
          _projectFilter = '&projectId=${newValue["id"]}';
        }
        break;
      case 'withTag':
        project['my'] = false;
        project['other'] = '';
        project['withoutTag'] = false;
        if (newValue == null) {
          project['withTag'] = '';
        } else {
          project['withTag'] = newValue['title'];
          _projectFilter = '&tag=${newValue["id"]}';
        }
        break;
      case 'withoutTag':
        project['my'] = false;
        project['other'] = '';
        project['withTag'] = '';
        project['withoutTag'] = !project['withoutTag'];
        if (project['withoutTag']) _projectFilter = '&tag=-1';
        break;
      default:
    }
    getSuitableResultCount();
  }

  void changeMilestone(String filter, [newValue]) {
    _milestoneFilter = '';
    switch (filter) {
      case 'my':
        milestone['no'] = false;
        milestone['other'] = '';
        milestone['my'] = !milestone['my'];
        if (milestone['my']) _milestoneFilter = '&mymilestones=true';
        break;
      case 'no':
        milestone['my'] = false;
        milestone['other'] = '';
        milestone['no'] = !milestone['no'];
        if (milestone['no']) _milestoneFilter = '&nomilestone=true';
        break;
      case 'other':
        milestone['my'] = false;
        milestone['no'] = false;
        if (newValue == null) {
          milestone['other'] = '';
        } else {
          milestone['other'] = newValue['title'];
          _milestoneFilter = '&milestone=${newValue["id"]}';
        }
        break;
      default:
    }
    getSuitableResultCount();
  }

  void changeStatus(String filter, [newValue]) {
    _statusFilter = '';
    switch (filter) {
      case 'open':
        status['closed'] = false;
        status['open'] = !status['open'];
        if (status['open']) _statusFilter = '&status=1';
        break;
      case 'closed':
        status['open'] = false;
        status['closed'] = !status['closed'];
        if (status['closed']) _statusFilter = '&status=2';
        break;
      default:
    }
    getSuitableResultCount();
  }

  Future<void> changeDeadline(
    String filter, {
    DateTime start,
    DateTime stop,
  }) async {
    _deadlineFilter = '';

    if (filter == 'overdue') {
      deadline['upcoming'] = false;
      deadline['today'] = false;
      deadline['custom']['selected'] = false;
      deadline['overdue'] = !deadline['overdue'];
      var dueDate = formatter.format(DateTime.now()).substring(0, 10);
      if (deadline['overdue'])
        _deadlineFilter = '&deadlineStop=$dueDate&status=open';
    }
    if (filter == 'today') {
      deadline['overdue'] = false;
      deadline['upcoming'] = false;
      deadline['custom']['selected'] = false;
      deadline['today'] = !deadline['today'];
      var dueDate = formatter.format(DateTime.now()).substring(0, 10);
      if (deadline['today'])
        _deadlineFilter = '&deadlineStart=$dueDate&deadlineStop=$dueDate';
    }
    if (filter == 'upcoming') {
      deadline['overdue'] = false;
      deadline['today'] = false;
      deadline['custom']['selected'] = false;
      deadline['upcoming'] = !deadline['upcoming'];
      var startDate = formatter.format(DateTime.now()).substring(0, 10);
      var stopDate = formatter
          .format(DateTime.now().add(const Duration(days: 7)))
          .substring(0, 10);
      if (deadline['upcoming'])
        _deadlineFilter = '&deadlineStart=$startDate&deadlineStop=$stopDate';
    }
    if (filter == 'custom') {
      deadline['overdue'] = false;
      deadline['today'] = false;
      deadline['upcoming'] = false;
      deadline['custom']['selected'] = !deadline['custom']['selected'];
      deadline['custom']['startDate'] = start;
      deadline['custom']['stopDate'] = stop;
      var startDate = formatter.format(start).substring(0, 10);
      var stopDate = formatter.format(stop).substring(0, 10);
      if (deadline['custom']['selected'])
        _deadlineFilter = '&deadlineStart=$startDate&deadlineStop=$stopDate';
    }

    getSuitableResultCount();
  }

  @override
  void getSuitableResultCount() async {
    suitableResultCount.value = -1;
    hasFilters.value = _hasFilters;

    var result = await _api.getTasksByParams(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      responsibleFilter: responsibleFilter,
      creatorFilter: creatorFilter,
      projectFilter: projectFilter,
      milestoneFilter: milestoneFilter,
      statusFilter: statusFilter,
      deadlineFilter: deadlineFilter,
      projectId: _projectId,
    );

    suitableResultCount.value = result.response.length;
  }

  @override
  void applyFilters() async {
    hasFilters.value = _hasFilters;
    await saveFilters();
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }

  @override
  void resetFilters() async {
    responsible['me'] = false;
    responsible['other'] = '';
    responsible['groups'] = '';
    responsible['no'] = false;

    creator['me'] = false;
    creator['other'] = '';

    project['my'] = false;
    project['other'] = '';
    project['withTag'] = '';
    project['withoutTag'] = false;

    milestone['my'] = false;
    milestone['no'] = false;
    milestone['other'] = '';

    status['open'] = false;
    status['closed'] = false;

    deadline['overdue'] = false;
    deadline['today'] = false;
    deadline['upcoming'] = false;
    deadline['custom'] = {
      'selected': false,
      'startDate': DateTime.now(),
      'stopDate': DateTime.now()
    };

    acceptedFilters.value = '';
    suitableResultCount.value = -1;

    _responsibleFilter = '';
    _creatorFilter = '';
    _projectFilter = '';
    _milestoneFilter = '';
    _statusFilter = '';
    _deadlineFilter = '';

    getSuitableResultCount();
  }

  Future<void> setupPreset(PresetTaskFilters preset) async {
    _selfId = await Get.find<UserController>().getUserId();

    switch (preset) {
      case PresetTaskFilters.myTasks:
        _statusFilter = '&status=1';

        _responsibleFilter = '&participant=$_selfId';
        responsible['me'] = true;
        break;
      case PresetTaskFilters.upcomming:
        _statusFilter = '&status=1';
        var startDate = formatter.format(DateTime.now());
        var stopDate =
            formatter.format(DateTime.now().add(const Duration(days: 7)));
        _deadlineFilter = '&deadlineStart=$startDate&deadlineStop=$stopDate';
        _responsibleFilter = '&participant=$_selfId';
        responsible['me'] = true;
        break;
      case PresetTaskFilters.last:
        var startDate = formatter.format(DateTime.now());
        var stopDate =
            formatter.format(DateTime.now().add(const Duration(days: 7)));

        _deadlineFilter = '&deadlineStart=$startDate&deadlineStop=$stopDate';
        break;
      case PresetTaskFilters.saved:
        await _getSavedFilters();
        break;
    }

    hasFilters.value = _hasFilters;
  }

  @override
  Future<void> saveFilters() async {
    var dLine = deadline;

    var dlineCustom = dateTimesToString(dLine['custom']);

    dLine['custom'] = dlineCustom;

    var map = {
      'responsible': {'buttons': responsible, 'value': _responsibleFilter},
      'creator': {'buttons': creator, 'value': _creatorFilter},
      'project': {'buttons': project, 'value': _projectFilter},
      'milestone': {'buttons': milestone, 'value': _milestoneFilter},
      'status': {'buttons': status, 'value': _statusFilter},
      'deadline': {'buttons': dLine, 'value': _deadlineFilter},
      'hasFilters': _hasFilters,
    };

    await _storage.write('taskFilters', map);
  }

  @override
  Future<void> loadFilters() async {
    responsible = {'me': true, 'other': '', 'groups': '', 'no': false}.obs;
    creator = {'me': false, 'other': ''}.obs;
    project = {
      'my': false,
      'other': '',
      'withTag': '',
      'withoutTag': false,
    }.obs;
    milestone = {'my': false, 'no': false, 'other': ''}.obs;
    status = {'open': false, 'closed': false}.obs;
    deadline = {
      'overdue': false,
      'today': false,
      'upcoming': false,
      'custom': {
        'selected': false,
        'startDate': DateTime.now(),
        'stopDate': DateTime.now()
      }
    }.obs;
  }

  Future<void> _getSavedFilters() async {
    var savedFilters = await _storage.read('taskFilters', returnCopy: true);

    if (savedFilters != null) {
      try {
        responsible = Map.from(savedFilters['responsible']['buttons']).obs;
        _responsibleFilter = savedFilters['responsible']['value'];

        creator = Map.from(savedFilters['creator']['buttons']).obs;
        _creatorFilter = savedFilters['creator']['value'];

        project = Map.from(savedFilters['project']['buttons']).obs;
        _projectFilter = savedFilters['project']['value'];

        milestone = Map.from(savedFilters['milestone']['buttons']).obs;
        _milestoneFilter = savedFilters['milestone']['value'];

        status = Map.from(savedFilters['status']['buttons']).obs;
        _statusFilter = savedFilters['status']['value'];

        var deadLineFilters = Map.from(savedFilters['deadline']['buttons']);

        var customDeadlineFilters = deadLineFilters['custom'];

        customDeadlineFilters =
            stringsToDateTime(customDeadlineFilters, ['startDate', 'stopDate']);

        deadLineFilters['custom'] = customDeadlineFilters;

        deadline = deadLineFilters.obs;
        _deadlineFilter ??= savedFilters['deadline']['value'];

        hasFilters.value = savedFilters['hasFilters'];
      } catch (_) {
        await loadFilters();
      }
    } else {
      _statusFilter = '&status=1';
      _responsibleFilter = '&participant=$_selfId';
      responsible['me'] = true;
    }
  }
}

enum PresetTaskFilters { last, myTasks, saved, upcomming }
