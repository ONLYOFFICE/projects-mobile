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
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/internal/utils/debug_print.dart';

class DiscussionsFilterController extends BaseFilterController {
  final DiscussionsService _api = locator<DiscussionsService>();
  final _sortController = Get.find<DiscussionsSortController>();
  final Storage _storage = locator<Storage>();

  final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.mmm');

  Function? applyFiltersDelegate;

  RxString acceptedFilters = ''.obs;

  String _authorFilter = '';
  String _statusFilter = '';
  String _projectFilter = '';
  String _creationDateFilter = '';
  String _otherFilter = '';

  String get authorFilter => _authorFilter;

  String get statusFilter => _statusFilter;

  String get projectFilter => _projectFilter;

  String get creationDateFilter => _creationDateFilter;

  String get otherFilter => _otherFilter;

  var _selfId;
  String? _projectId;

  bool get _hasFilters =>
      _authorFilter.isNotEmpty ||
      _statusFilter.isNotEmpty ||
      _projectFilter.isNotEmpty ||
      _creationDateFilter.isNotEmpty ||
      _otherFilter.isNotEmpty;

  late RxMap author;
  late RxMap status;
  late RxMap creationDate;
  late RxMap project;
  late RxMap other;

  @override
  void onInit() async {
    await loadFilters();
    super.onInit();
  }

  @override
  Future<void> restoreFilters() async {
    suitableResultCount.value = -1;
    hasFilters.value = _hasFilters;

    await _getSavedFilters();
  }

  @override
  String get filtersTitle => plural('discussionsFilterConfirm', suitableResultCount.value);

  DiscussionsFilterController() {
    suitableResultCount = (-1).obs;
  }

  set projectId(String value) => _projectId = value;

  Future<void> changeAuthor(String filter, [dynamic newValue = '']) async {
    _selfId = await Get.find<UserController>().getUserId();

    _authorFilter = '';
    switch (filter) {
      case 'me':
        author['other'] = '';
        author['me'] = !(author['me'] as bool);
        if (author['me'] as bool) _authorFilter = '&participant=$_selfId';
        break;
      case 'other':
        author['me'] = false;
        if (newValue == null) {
          author['other'] = '';
        } else {
          author['other'] = newValue['displayName'];
          _authorFilter = '&participant=${newValue["id"]}';
        }
        break;
      default:
    }
    await getSuitableResultCount();
  }

  Future<void> changeStatus(String filter) async {
    _selfId = await Get.find<UserController>().getUserId();

    _statusFilter = '';
    if (filter == 'open') {
      status['archived'] = false;
      status['open'] = !(status['open'] as bool);
      if (status['open'] as bool) _statusFilter = '&status=open';
    }
    if (filter == 'archived') {
      status['open'] = false;
      status['archived'] = !(status['archived'] as bool);
      if (status['archived'] as bool) _statusFilter = '&status=archived';
    }
    await getSuitableResultCount();
  }

  Future<void> changeProject(String filter, [dynamic newValue = '']) async {
    _projectFilter = '';
    switch (filter) {
      case 'my':
        project['other'] = '';
        project['withTag'] = '';
        project['withoutTag'] = false;
        project['my'] = !(project['my'] as bool);
        if (project['my'] as bool) _projectFilter = '&myprojects=true';
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
        project['withoutTag'] = !(project['withoutTag'] as bool);
        if (project['withoutTag'] as bool) _projectFilter = '&tag=-1';
        break;
      default:
    }
    await getSuitableResultCount();
  }

  void changeOther(String filter) {
    _otherFilter = '';
    switch (filter) {
      case 'subscribed':
        other['subscribed'] = !(other['subscribed'] as bool);
        if (other['subscribed'] as bool) _otherFilter = '&follow=true';
        break;
      default:
    }
    getSuitableResultCount();
  }

  Future<void> changeCreationDate(
    String filter, {
    DateTime? start,
    DateTime? stop,
  }) async {
    _creationDateFilter = '';

    if (filter == 'today') {
      creationDate['last7Days'] = false;
      creationDate['custom']['selected'] = false;
      creationDate['today'] = !(creationDate['today'] as bool);
      final dueDate = formatter.format(DateTime.now()).substring(0, 10);
      if (creationDate['today'] as bool) {
        _creationDateFilter = '&createdStart=$dueDate&createdStop=$dueDate';
      }
    }
    if (filter == 'last7Days') {
      creationDate['today'] = false;
      creationDate['custom']['selected'] = false;
      creationDate['last7Days'] = !(creationDate['last7Days'] as bool);
      final startDate =
          formatter.format(DateTime.now().add(const Duration(days: -7))).substring(0, 10);
      final stopDate = formatter.format(DateTime.now()).substring(0, 10);

      if (creationDate['last7Days'] as bool) {
        _creationDateFilter = '&createdStart=$startDate&createdStop=$stopDate';
      }
    }
    if (filter == 'custom') {
      creationDate['today'] = false;
      creationDate['last7Days'] = false;
      creationDate['custom']['selected'] = !(creationDate['custom']['selected'] as bool);
      creationDate['custom']['startDate'] = start;
      creationDate['custom']['stopDate'] = stop;
      final startDate = formatter.format(start!).substring(0, 10);
      final stopDate = formatter.format(stop!).substring(0, 10);
      if (creationDate['custom']['selected'] as bool) {
        _creationDateFilter = '&createdStart=$startDate&createdStop=$stopDate';
      }
    }

    await getSuitableResultCount();
  }

  @override
  Future<void> getSuitableResultCount() async {
    suitableResultCount.value = -1;
    hasFilters.value = _hasFilters;
    final result = await _api.getDiscussionsByParams(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      authorFilter: _authorFilter,
      statusFilter: _statusFilter,
      projectFilter: _projectFilter,
      creationDateFilter: _creationDateFilter,
      otherFilter: _otherFilter,
      projectId: _projectId,
    );

    if (result != null) {
      suitableResultCount.value = result.response!.length;
    }
  }

  @override
  Future<void> resetFilters() async {
    author['me'] = false;
    author['other'] = '';

    status['open'] = false;
    status['archived'] = false;

    project['my'] = false;
    project['other'] = '';
    project['withTag'] = '';
    project['withoutTag'] = false;

    other['subscribed'] = false;

    creationDate['today'] = false;
    creationDate['last7Days'] = false;
    creationDate['custom'] = {
      'selected': false,
      'startDate': DateTime.now(),
      'stopDate': DateTime.now()
    };

    acceptedFilters.value = '';

    _authorFilter = '';
    _statusFilter = '';
    _projectFilter = '';
    _otherFilter = '';
    _creationDateFilter = '';

    await getSuitableResultCount();
  }

  @override
  Future<void> applyFilters() async {
    hasFilters.value = _hasFilters;

    applyFiltersDelegate?.call();

    await saveFilters();
  }

  Future<void> setupPreset(PresetDiscussionFilters preset) async {
    _selfId = await Get.find<UserController>().getUserId();

    if (preset == PresetDiscussionFilters.myDiscussions) {
      _authorFilter = '&participant=$_selfId';
      author['me'] = true;
    } else if (preset == PresetDiscussionFilters.saved) {
      await _getSavedFilters();
    }

    hasFilters.value = _hasFilters;
  }

  @override
  Future<void> saveFilters() async {
    final creation = Map.from(creationDate);

    final startDate = creation['custom']['startDate'].toIso8601String();
    final stopDate = creation['custom']['stopDate'].toIso8601String();

    creation['custom'] = {
      'selected': creationDate['custom']['selected'],
      'startDate': startDate,
      'stopDate': stopDate,
    };

    await _storage.write(
      'discussionFilters',
      {
        'author': {'buttons': Map.from(author), 'value': _authorFilter},
        'project': {'buttons': Map.from(project), 'value': _projectFilter},
        'status': {'buttons': Map.from(status), 'value': _statusFilter},
        'creationDate': {'buttons': creation, 'value': _creationDateFilter},
        'other': {'buttons': Map.from(other), 'value': _otherFilter},
        'hasFilters': _hasFilters,
      },
    );
  }

  @override
  Future<void> loadFilters() async {
    author = {'me': false, 'other': ''}.obs;
    project = {
      'my': false,
      'other': '',
      'withTag': '',
      'withoutTag': false,
    }.obs;
    status = {'open': false, 'archived': false}.obs;
    creationDate = {
      'today': false,
      'last7Days': false,
      'custom': {'selected': false, 'startDate': DateTime.now(), 'stopDate': DateTime.now()}
    }.obs;
    other = {'subscribed': false}.obs;

    _authorFilter = '';
    _statusFilter = '';
    _projectFilter = '';
    _otherFilter = '';
    _creationDateFilter = '';

    hasFilters.value = _hasFilters;
  }

  Future<void> _getSavedFilters() async {
    final savedFilters = await _storage.read('discussionFilters', returnCopy: true);

    if (savedFilters != null) {
      try {
        author.value =
            Map<String, Object>.from(savedFilters['author']['buttons'] as Map<dynamic, dynamic>);
        _authorFilter = savedFilters['author']['value'] as String;

        project.value =
            Map<String, Object>.from(savedFilters['project']['buttons'] as Map<dynamic, dynamic>);
        _projectFilter = savedFilters['project']['value'] as String;

        status.value =
            Map<String, bool>.from(savedFilters['status']['buttons'] as Map<dynamic, dynamic>);
        _statusFilter = savedFilters['status']['value'] as String;

        final Map creation = Map<String, Object>.from(
            savedFilters['creationDate']['buttons'] as Map<dynamic, dynamic>);
        creation['custom'] = {
          'selected': creation['custom']['selected'],
          'startDate': DateTime.parse(creation['custom']['startDate'] as String),
          'stopDate': DateTime.parse(creation['custom']['stopDate'] as String),
        };
        creationDate.value = creation;
        _creationDateFilter = savedFilters['creationDate']['value'] as String;

        other.value =
            Map<String, bool>.from(savedFilters['other']['buttons'] as Map<dynamic, dynamic>);
        _otherFilter = savedFilters['other']['value'] as String;

        hasFilters.value = savedFilters['hasFilters'] as bool;
      } catch (e) {
        printWarning('Discussions filter loading error: $e');
        await loadFilters();
      }
    } else {
      await loadFilters();
    }
  }
}

enum PresetDiscussionFilters { myDiscussions, saved }
