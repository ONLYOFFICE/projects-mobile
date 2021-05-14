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
import 'package:intl/intl.dart';
import 'package:projects/data/services/task_service.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class TaskFilterController extends BaseFilterController {
  final _api = locator<TaskService>();
  final _sortController = Get.find<TasksSortController>();

  final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.mmm');

  Function applyFiltersDelegate;

  RxString acceptedFilters = ''.obs;

  String _responsibleFilter = '';
  String _creatorFilter = '';
  String _projectFilter = '';
  String _milestoneFilter = '';
  String _deadlineFilter = '';

  String get responsibleFilter => _responsibleFilter;
  String get creatorFilter => _creatorFilter;
  String get projectFilter => _projectFilter;
  String get milestoneFilter => _milestoneFilter;
  String get deadlineFilter => _deadlineFilter;

  var _selfId;
  String _projectId;

  @override
  bool get hasFilters =>
      _responsibleFilter.isNotEmpty ||
      _creatorFilter.isNotEmpty ||
      _projectFilter.isNotEmpty ||
      _deadlineFilter.isNotEmpty ||
      _milestoneFilter.isNotEmpty;

  RxMap<String, dynamic> responsible =
      {'Me': false, 'Other': '', 'Groups': '', 'No': false}.obs;

  RxMap<String, dynamic> creator = {'Me': false, 'Other': ''}.obs;

  RxMap<String, dynamic> project =
      {'My': false, 'Other': '', 'With tag': '', 'Without tag': false}.obs;

  RxMap<String, dynamic> milestone =
      {'My': false, 'No': false, 'Other': ''}.obs;

  RxMap<String, dynamic> deadline = {
    'overdue': false,
    'today': false,
    'upcoming': false,
    'custom': {
      'selected': false,
      'startDate': DateTime.now(),
      'stopDate': DateTime.now()
    }
  }.obs;

  TaskFilterController() {
    filtersTitle = 'TASKS';
    suitableResultCount = (-1).obs;
  }

  set projectId(String value) => _projectId = value;

  void changeResponsible(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _responsibleFilter = '';

    switch (filter) {
      case 'Me':
        responsible['Other'] = '';
        responsible['Groups'] = '';
        responsible['No'] = false;
        responsible['Me'] = !responsible['Me'];
        if (responsible['Me']) _responsibleFilter = '&participant=$_selfId';
        break;
      case 'Other':
        responsible['Me'] = false;
        responsible['Groups'] = '';
        responsible['No'] = false;
        if (newValue == null) {
          responsible['Other'] = '';
        } else {
          responsible['Other'] = newValue['displayName'];
          _responsibleFilter = '&participant=${newValue["id"]}';
        }
        break;
      case 'Groups':
        responsible['Me'] = false;
        responsible['Other'] = '';
        responsible['No'] = false;
        if (newValue == null) {
          responsible['Groups'] = '';
        } else {
          responsible['Groups'] = newValue['name'];
          _responsibleFilter = '&departament=${newValue["id"]}';
        }
        break;
      case 'No':
        responsible['Me'] = false;
        responsible['Other'] = '';
        responsible['Groups'] = '';
        responsible['No'] = !responsible['No'];
        if (responsible['No']) {
          _responsibleFilter =
              '&participant=00000000-0000-0000-0000-000000000000';
        }
        break;
      default:
    }
    getSuitableTasksCount();
  }

  Future<void> changeCreator(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _creatorFilter = '';
    if (filter == 'Me') {
      creator['Other'] = '';
      creator['Me'] = !creator['Me'];
      if (creator['Me']) _creatorFilter = '&creator=$_selfId';
    }
    if (filter == 'Other') {
      creator['Me'] = false;
      if (newValue == null) {
        creator['Other'] = '';
      } else {
        creator['Other'] = newValue['displayName'];
        _creatorFilter = '&creator=${newValue["id"]}';
      }
    }
    getSuitableTasksCount();
  }

  void changeProject(String filter, [newValue = '']) async {
    _projectFilter = '';
    switch (filter) {
      case 'My':
        project['Other'] = '';
        project['With tag'] = '';
        project['Without tag'] = false;
        project['My'] = !project['My'];
        if (project['My']) _projectFilter = '&myprojects=true';
        break;
      case 'Other':
        project['My'] = false;
        project['With tag'] = '';
        project['Without tag'] = false;
        if (newValue == null) {
          project['Other'] = '';
        } else {
          project['Other'] = newValue['title'];
          _projectFilter = '&projectId=${newValue["id"]}';
        }
        break;
      case 'With tag':
        project['My'] = false;
        project['Other'] = '';
        project['Without tag'] = false;
        if (newValue == null) {
          project['With tag'] = '';
        } else {
          project['With tag'] = newValue['title'];
          _projectFilter = '&tag=${newValue["id"]}';
        }
        break;
      case 'Without tag':
        project['My'] = false;
        project['Other'] = '';
        project['With tag'] = '';
        project['Without tag'] = !project['Without tag'];
        if (project['Without tag']) _projectFilter = '&tag=-1';
        break;
      default:
    }
    getSuitableTasksCount();
  }

  void changeMilestone(String filter, [newValue]) {
    _milestoneFilter = '';
    switch (filter) {
      case 'My':
        milestone['No'] = false;
        milestone['Other'] = '';
        milestone['My'] = !milestone['My'];
        if (milestone['My']) _milestoneFilter = '&mymilestones=true';
        break;
      case 'No':
        milestone['My'] = false;
        milestone['Other'] = '';
        milestone['No'] = !milestone['No'];
        if (milestone['No']) _milestoneFilter = '&nomilestone=true';
        break;
      case 'Other':
        milestone['My'] = false;
        milestone['No'] = false;
        if (newValue == null) {
          milestone['Other'] = '';
        } else {
          milestone['Other'] = newValue['title'];
          _milestoneFilter = '&milestone=${newValue["id"]}';
        }
        break;
      default:
    }
    getSuitableTasksCount();
  }

  Future<void> changeDeadline(String filter,
      {DateTime start, DateTime stop}) async {
    _deadlineFilter = '';

    if (filter == 'overdue') {
      deadline['upcoming'] = false;
      deadline['today'] = false;
      deadline['custom']['selected'] = false;
      deadline['overdue'] = !deadline['overdue'];
      var dueDate = formatter.format(DateTime.now());
      if (deadline['overdue']) _deadlineFilter = '&deadlineStop=$dueDate';
    }
    if (filter == 'today') {
      deadline['overdue'] = false;
      deadline['upcoming'] = false;
      deadline['custom']['selected'] = false;
      deadline['today'] = !deadline['today'];
      var dueDate = formatter.format(DateTime.now());
      if (deadline['today'])
        _deadlineFilter = '&deadlineStart=$dueDate&deadlineStop=$dueDate';
    }
    if (filter == 'upcoming') {
      deadline['overdue'] = false;
      deadline['today'] = false;
      deadline['custom']['selected'] = false;
      deadline['upcoming'] = !deadline['upcoming'];
      var startDate = formatter.format(DateTime.now());
      var stopDate =
          formatter.format(DateTime.now().add(const Duration(days: 7)));
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
      var startDate = formatter.format(start);
      var stopDate = formatter.format(stop);
      if (deadline['custom']['selected'])
        _deadlineFilter = '&deadlineStart=$startDate&deadlineStop=$stopDate';
    }

    getSuitableTasksCount();
  }

  void getSuitableTasksCount() async {
    suitableResultCount.value = -1;

    var result = await _api.getTasksByParams(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      responsibleFilter: responsibleFilter,
      creatorFilter: creatorFilter,
      projectFilter: projectFilter,
      milestoneFilter: milestoneFilter,
      deadlineFilter: deadlineFilter,
      projectId: _projectId,
    );

    suitableResultCount.value = result.response.length;
  }

  @override
  void resetFilters() async {
    responsible.value = {'Me': false, 'Other': '', 'Groups': '', 'No': false};
    creator.value = {'Me': false, 'Other': ''};
    project.value = {
      'My': false,
      'Other': '',
      'With tag': '',
      'Without tag': false
    };
    milestone.value = {'My': false, 'No': false, 'Other': ''};

    deadline.value = {
      'overdue': false,
      'today': false,
      'upcoming': false,
      'custom': {
        'selected': false,
        'startDate': DateTime.now(),
        'stopDate': DateTime.now()
      }
    };

    acceptedFilters.value = '';
    suitableResultCount.value = -1;

    _responsibleFilter = '';
    _creatorFilter = '';
    _projectFilter = '';
    _milestoneFilter = '';
    _deadlineFilter = '';

    applyFilters();
  }

  @override
  void applyFilters() async {
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }

  Future<void> setupPreset(String preset) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    switch (preset) {
      case 'myTasks':
        _responsibleFilter = '&participant=$_selfId';

        break;
      case 'upcomming':
        var startDate = formatter.format(DateTime.now());
        var stopDate =
            formatter.format(DateTime.now().add(const Duration(days: 7)));

        _deadlineFilter = '&deadlineStart=$startDate&deadlineStop=$stopDate';
        break;
    }
  }
}
