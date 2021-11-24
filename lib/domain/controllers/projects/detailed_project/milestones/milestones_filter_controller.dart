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
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class MilestonesFilterController extends BaseFilterController {
  final MilestoneService? _api = locator<MilestoneService>();
  final Storage? _storage = locator<Storage>();

  final _sortController = Get.find<MilestonesSortController>();
  Function? applyFiltersDelegate;

  String? _taskResponsibleFilter = '';
  String? _milestoneResponsibleFilter = '';
  String? _deadlineFilter = '';
  String? _statusFilter = '';

  String? _currentAppliedResponsibleFilter = '';
  String? _currentAppliedMilestoneResponsibleFilter = '';
  String? _currentAppliedDeadlineFilter = '';
  String? _currentAppliedStatusFilter = '';

  String? get taskResponsibleFilter => _taskResponsibleFilter;
  String? get milestoneResponsibleFilter => _milestoneResponsibleFilter;
  String? get statusFilter => _statusFilter;
  String? get deadlineFilter => _deadlineFilter;

  var _selfId;
  String? _projectId;
  set projectId(String value) => _projectId = value;

  bool get _hasFilters =>
      _milestoneResponsibleFilter!.isNotEmpty ||
      _taskResponsibleFilter!.isNotEmpty ||
      _deadlineFilter!.isNotEmpty ||
      _statusFilter!.isNotEmpty;

  RxMap? milestoneResponsible;
  RxMap? taskResponsible;
  late RxMap deadline;
  RxMap? status;

  late Map _currentAppliedMilestoneResponsible;
  late Map _currentAppliedTaskResponsible;
  late Map _currentAppliedDeadline;
  late Map _currentAppliedStatus;

  @override
  Future<void> restoreFilters() async {
    _restoreFilterState();

    hasFilters.value = _hasFilters;
    suitableResultCount.value = -1;

    // await _getSavedFilters();
  }

  @override
  String get filtersTitle =>
      plural('milestonesFilterConfirm', suitableResultCount.value);

  MilestonesFilterController() {
    suitableResultCount = (-1).obs;
  }

  @override
  void onInit() async {
    await loadFilters();
    super.onInit();
  }

  Future<void> changeResponsible(String filter, [newValue = '']) async {
    _selfId = await Get.find<UserController>().getUserId();
    _milestoneResponsibleFilter = '';
    if (filter == 'me') {
      milestoneResponsible!['other'] = '';
      milestoneResponsible!['me'] = !(milestoneResponsible!['me'] as bool);
      if (milestoneResponsible!['me'] as bool)
        _milestoneResponsibleFilter = '&milestoneResponsible=$_selfId';
    }
    if (filter == 'other') {
      milestoneResponsible!['me'] = false;
      if (newValue == null) {
        milestoneResponsible!['other'] = '';
      } else {
        milestoneResponsible!['other'] = newValue['displayName'];
        _milestoneResponsibleFilter = '&milestoneResponsible=${newValue["id"]}';
      }
    }
    getSuitableResultCount();
  }

  Future<void> changeTasksResponsible(String filter, [newValue = '']) async {
    _selfId = await Get.find<UserController>().getUserId();
    _taskResponsibleFilter = '';
    if (filter == 'me') {
      taskResponsible!['other'] = '';
      taskResponsible!['me'] = !(taskResponsible!['me'] as bool);
      if (taskResponsible!['me'] as bool)
        _taskResponsibleFilter = '&participant=$_selfId';
    }
    if (filter == 'other') {
      taskResponsible!['me'] = false;
      if (newValue == null) {
        taskResponsible!['other'] = '';
      } else {
        taskResponsible!['other'] = newValue['displayName'];
        _taskResponsibleFilter = '&taskResponsible=${newValue["id"]}';
      }
    }

    getSuitableResultCount();
  }

  Future<void> changeDeadline(String filter,
      {DateTime? start, DateTime? stop}) async {
    _deadlineFilter = '';
    final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.mmm');

    if (filter == 'overdue') {
      deadline['upcoming'] = false;
      deadline['today'] = false;
      deadline['custom']['selected'] = false;
      deadline['overdue'] = !(deadline['overdue'] as bool);
      var dueDate = formatter.format(DateTime.now());
      if (deadline['overdue'] as bool)
        _deadlineFilter = '&deadlineStop=$dueDate';
    }
    if (filter == 'today') {
      deadline['overdue'] = false;
      deadline['upcoming'] = false;
      deadline['custom']['selected'] = false;
      deadline['today'] = !(deadline['today'] as bool);
      var dueDate = formatter.format(DateTime.now());
      if (deadline['today'] as bool)
        _deadlineFilter = '&deadlineStart=$dueDate&deadlineStop=$dueDate';
    }
    if (filter == 'upcoming') {
      deadline['overdue'] = false;
      deadline['today'] = false;
      deadline['custom']['selected'] = false;
      deadline['upcoming'] = !(deadline['upcoming'] as bool);
      var startDate = formatter.format(DateTime.now());
      var stopDate =
          formatter.format(DateTime.now().add(const Duration(days: 7)));
      if (deadline['upcoming'] as bool)
        _deadlineFilter = '&deadlineStart=$startDate&deadlineStop=$stopDate';
    }
    if (filter == 'custom') {
      deadline['overdue'] = false;
      deadline['today'] = false;
      deadline['upcoming'] = false;
      deadline['custom']['selected'] =
          !(deadline['custom']['selected'] as bool);
      deadline['custom']['startDate'] = start;
      deadline['custom']['stopDate'] = stop;
      var startDate = formatter.format(start!);
      var stopDate = formatter.format(stop!);
      if (deadline['custom']['selected'] as bool)
        _deadlineFilter = '&deadlineStart=$startDate&deadlineStop=$stopDate';
    }

    getSuitableResultCount();
  }

  void changeStatus(String filter, [newValue = '']) async {
    _statusFilter = '';
    switch (filter) {
      case 'active':
        status!['active'] = !(status!['active'] as bool);
        status!['paused'] = false;
        status!['closed'] = false;

        if (status!['active'] as bool) _statusFilter = '&status=open';
        break;
      case 'paused':
        status!['active'] = false;
        status!['paused'] = !(status!['paused'] as bool);
        status!['closed'] = false;

        if (status!['paused'] as bool) _statusFilter = '&status=paused';
        break;
      case 'closed':
        status!['active'] = false;
        status!['paused'] = false;
        status!['closed'] = !(status!['closed'] as bool);

        if (status!['closed'] as bool) _statusFilter = '&status=closed';
        break;
      default:
    }
    getSuitableResultCount();
  }

  @override
  void getSuitableResultCount() async {
    suitableResultCount.value = -1;
    hasFilters.value = _hasFilters;

    var result = await (_api!.milestonesByFilter(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectId: _projectId.toString(),
      milestoneResponsibleFilter: milestoneResponsibleFilter,
      taskResponsibleFilter: taskResponsibleFilter,
      statusFilter: statusFilter,
      deadlineFilter: deadlineFilter,
    ) as Future<List<Milestone>>);

    suitableResultCount.value = result.length;
  }

  @override
  void resetFilters() async {
    milestoneResponsible!['me'] = false;
    milestoneResponsible!['other'] = '';

    taskResponsible!['me'] = false;
    taskResponsible!['other'] = '';

    status!['active'] = false;
    status!['paused'] = false;
    status!['closed'] = false;

    deadline['overdue'] = false;
    deadline['today'] = false;
    deadline['upcoming'] = false;
    deadline['custom'] = {
      'selected': false,
      'startDate': DateTime.now(),
      'stopDate': DateTime.now()
    };

    _milestoneResponsibleFilter = '';
    _taskResponsibleFilter = '';
    _deadlineFilter = '';
    _statusFilter = '';

    getSuitableResultCount();
  }

  @override
  void applyFilters() async {
    hasFilters.value = _hasFilters;
    suitableResultCount.value = -1;

    if (applyFiltersDelegate != null) applyFiltersDelegate!();

    _updateFilterState();
  }

  // UNUSED
  @override
  Future<void> saveFilters() async {
    var d = Map.from(deadline);

    var startDate = deadline['custom']['startDate'].toIso8601String();
    var stopDate = deadline['custom']['stopDate'].toIso8601String();

    d['custom'] = {
      'selected': deadline['custom']['selected'],
      'startDate': startDate,
      'stopDate': stopDate,
    };

    await _storage!.write(
      'milestonesFilter',
      {
        'milestoneResponsible': {
          'buttons': milestoneResponsible,
          'value': _milestoneResponsibleFilter
        },
        'taskResponsible': {
          'buttons': taskResponsible,
          'value': _taskResponsibleFilter
        },
        'status': {'buttons': status, 'value': _statusFilter},
        'deadline': {'buttons': d, 'value': _deadlineFilter},
        'hasFilters': _hasFilters,
      },
    );
  }

  @override
  Future<void> loadFilters() async {
    milestoneResponsible = {'me': false, 'other': ''}.obs;
    taskResponsible = {'me': false, 'other': ''}.obs;
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
    status = {'active': false, 'paused': false, 'closed': false}.obs;
    _currentAppliedMilestoneResponsible = Map.from(milestoneResponsible!);
    _currentAppliedTaskResponsible = Map.from(taskResponsible!);
    _currentAppliedDeadline = Map.from(deadline);
    _currentAppliedStatus = Map.from(status!);

    _updateFilterState();
  }

  // UNUSED
  // ignore: unused_element
  Future<void> _getSavedFilters() async {
    var savedFilters =
        await _storage!.read('milestoneFilters', returnCopy: true);

    if (savedFilters != null) {
      try {
        milestoneResponsible =
            Map.from(savedFilters['milestoneResponsible']['buttons'] as Map)
                .obs;
        _milestoneResponsibleFilter =
            savedFilters['milestoneResponsible']['value'] as String;

        taskResponsible =
            Map.from(savedFilters['taskResponsible']['buttons'] as Map).obs;
        _taskResponsibleFilter =
            savedFilters['taskResponsible']['value'] as String;

        status = Map.from(savedFilters['status']['buttons'] as Map).obs;
        _statusFilter = savedFilters['status']['value'] as String;

        Map d = savedFilters['deadline']['buttons'] as Map;
        d['custom'] = {
          'selected': d['custom']['selected'],
          'startDate': DateTime.parse(d['custom']['startDate'] as String),
          'stopDate': DateTime.parse(d['custom']['stopDate'] as String),
        };
        deadline = d.obs;
        _deadlineFilter = savedFilters['deadline']['value'] as String;

        hasFilters.value = savedFilters['hasFilters'] as bool;
      } catch (e) {
        print(e);
        await loadFilters();
      }
    } else {
      await loadFilters();
    }
  }

  void _updateFilterState() {
    _currentAppliedDeadline = Map.from(deadline);
    _currentAppliedStatus = Map.from(status!);
    _currentAppliedTaskResponsible = Map.from(taskResponsible!);
    _currentAppliedMilestoneResponsible = Map.from(milestoneResponsible!);

    _currentAppliedResponsibleFilter = _taskResponsibleFilter;
    _currentAppliedMilestoneResponsibleFilter = _milestoneResponsibleFilter;
    _currentAppliedDeadlineFilter = _deadlineFilter;
    _currentAppliedStatusFilter = _statusFilter;
  }

  void _restoreFilterState() {
    milestoneResponsible = RxMap.from(_currentAppliedMilestoneResponsible);
    taskResponsible = RxMap.from(_currentAppliedTaskResponsible);
    deadline = RxMap.from(_currentAppliedDeadline);
    status = RxMap.from(_currentAppliedStatus);

    _taskResponsibleFilter = _currentAppliedResponsibleFilter;
    _milestoneResponsibleFilter = _currentAppliedMilestoneResponsibleFilter;
    _deadlineFilter = _currentAppliedDeadlineFilter;
    _statusFilter = _currentAppliedStatusFilter;
  }
}
