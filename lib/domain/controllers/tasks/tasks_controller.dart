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
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/task_service.dart';

class TasksController extends BaseController {
  final _api = locator<TaskService>();

  var paginationController =
      Get.put(PaginationController(), tag: 'TasksController');

  final _sortController = Get.find<TasksSortController>();
  final _filterController = Get.find<TaskFilterController>();

  RxBool loaded = false.obs;

  TasksController() {
    _sortController.updateSortDelegate = reloadTasks;

    _filterController.applyFiltersDelegate = () {
      hasFilters.value = _filterController.hasFilters;
      reloadTasks();
    };

    paginationController.loadDelegate = () async {
      await _getTasks();
    };
    paginationController.refreshDelegate = () async {
      await _getTasks(needToClear: true);
    };

    paginationController.pullDownEnabled = true;
  }

  @override
  String get screenName => 'Tasks';

  @override
  RxList get itemList => paginationController.data;

  Future reloadTasks() async {
    loaded.value = false;
    await _getTasks(needToClear: true);
    loaded.value = true;
  }

  Future getTasks() async {
    loaded.value = false;
    await _getTasks();
    loaded.value = true;
  }

  Future _getTasks({needToClear = false}) async {
    var result = await _api.getTasksByParams(
      startIndex: paginationController.startIndex,
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      responsibleFilter: _filterController.responsibleFilter,
      creatorFilter: _filterController.creatorFilter,
      projectFilter: _filterController.projectFilter,
      milestoneFilter: _filterController.milestoneFilter,
    );
    paginationController.total = result.total;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response);
  }
}
