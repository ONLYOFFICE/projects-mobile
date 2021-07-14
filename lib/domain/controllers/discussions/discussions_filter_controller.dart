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
import 'package:projects/domain/controllers/base_filter_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class DiscussionsFilterController extends BaseFilterController {
  final _api = locator<DiscussionsService>();
  final _sortController = Get.find<DiscussionsSortController>();

  final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.mmm');

  Function applyFiltersDelegate;

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
  String _projectId;

  bool get _hasFilters =>
      _authorFilter.isNotEmpty ||
      _statusFilter.isNotEmpty ||
      _projectFilter.isNotEmpty ||
      _creationDateFilter.isNotEmpty ||
      _otherFilter.isNotEmpty;

  RxMap<String, dynamic> author = {'me': false, 'other': ''}.obs;

  RxMap<String, dynamic> status = {'open': false, 'archived': false}.obs;

  RxMap<String, dynamic> creationDate = {
    'today': false,
    'last7Days': false,
    'custom': {
      'selected': false,
      'startDate': DateTime.now(),
      'stopDate': DateTime.now()
    }
  }.obs;

  RxMap<String, dynamic> project =
      {'my': false, 'other': '', 'withTag': '', 'withoutTag': false}.obs;

  RxMap<String, dynamic> other = {'subscribed': false}.obs;

  @override
  String get filtersTitle =>
      plural('discussionsFilterConfirm', suitableResultCount.value);

  DiscussionsFilterController() {
    suitableResultCount = (-1).obs;
  }

  set projectId(String value) => _projectId = value;

  void changeAuthor(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _authorFilter = '';
    switch (filter) {
      case 'me':
        author['other'] = '';
        author['me'] = !author['me'];
        if (author['me']) _authorFilter = '&participant=$_selfId';
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
    getSuitableResultCount();
  }

  Future<void> changeStatus(String filter, [newValue = false]) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _statusFilter = '';
    if (filter == 'open') {
      status['archived'] = false;
      status['open'] = !status['open'];
      if (status['open']) _statusFilter = '&status=open';
    }
    if (filter == 'archived') {
      status['open'] = false;
      status['archived'] = !status['archived'];
      if (status['archived']) _statusFilter = '&status=archived';
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

  void changeOther(String filter, [newValue]) {
    _otherFilter = '';
    switch (filter) {
      case 'subscribed':
        other['subscribed'] = !other['subscribed'];
        if (other['subscribed']) _otherFilter = '&follow=true';
        break;
      default:
    }
    getSuitableResultCount();
  }

  Future<void> changeCreationDate(
    String filter, {
    DateTime start,
    DateTime stop,
  }) async {
    _creationDateFilter = '';

    if (filter == 'today') {
      creationDate['last7Days'] = false;
      creationDate['custom']['selected'] = false;
      creationDate['today'] = !creationDate['today'];
      var dueDate = formatter.format(DateTime.now()).substring(0, 10);
      if (creationDate['today'])
        _creationDateFilter = '&createdStart=$dueDate&createdStop=$dueDate';
    }
    if (filter == 'last7Days') {
      creationDate['today'] = false;
      creationDate['custom']['selected'] = false;
      creationDate['last7Days'] = !creationDate['last7Days'];
      var startDate = formatter
          .format(DateTime.now().add(const Duration(days: -7)))
          .substring(0, 10);
      var stopDate = formatter.format(DateTime.now()).substring(0, 10);

      if (creationDate['last7Days'])
        _creationDateFilter = '&createdStart=$startDate&createdStop=$stopDate';
    }
    if (filter == 'custom') {
      creationDate['today'] = false;
      creationDate['last7Days'] = false;
      creationDate['custom']['selected'] = !creationDate['custom']['selected'];
      creationDate['custom']['startDate'] = start;
      creationDate['custom']['stopDate'] = stop;
      var startDate = formatter.format(start).substring(0, 10);
      var stopDate = formatter.format(stop).substring(0, 10);
      if (creationDate['custom']['selected'])
        _creationDateFilter = '&createdStart=$startDate&createdStop=$stopDate';
    }

    getSuitableResultCount();
  }

  @override
  void getSuitableResultCount() async {
    suitableResultCount.value = -1;
    hasFilters.value = _hasFilters;

    var result = await _api.getDiscussionsByParams(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      authorFilter: _authorFilter,
      statusFilter: _statusFilter,
      projectFilter: _projectFilter,
      creationDateFilter: _creationDateFilter,
      otherFilter: _otherFilter,
      projectId: _projectId,
    );

    suitableResultCount.value = result.response.length;
  }

  @override
  void resetFilters() async {
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
    suitableResultCount.value = -1;

    _authorFilter = '';
    _statusFilter = '';
    _projectFilter = '';
    _otherFilter = '';
    _creationDateFilter = '';

    getSuitableResultCount();
  }

  @override
  void applyFilters() async {
    hasFilters.value = _hasFilters;
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }

  Future<void> setupPreset(String preset) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    switch (preset) {
      case 'myDiscussions':
        _authorFilter = '&participant=$_selfId';
        break;
    }
  }
}
