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
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';

import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_filter_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_sort_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class MilestonesDataSource extends GetxController {
  final _api = locator<MilestoneService>();

  final paginationController =
      Get.put(PaginationController(), tag: 'MilestonesDataSource');

  final _sortController = Get.find<MilestonesSortController>();
  final _filterController = Get.find<MilestonesFilterController>();

  List<PortalUser> _team;

  ProjectDetailed _projectDetailed;

  MilestonesSortController get sortController => _sortController;
  MilestonesFilterController get filterController => _filterController;

  int get itemCount => paginationController.data.length;
  RxList get itemList => paginationController.data;

  RxBool loaded = false.obs;

  var hasFilters = false.obs;

  int _projectId;

  String _selfId;
  final _userController = Get.find<UserController>();

  var fabIsVisible = false.obs;

  MilestonesDataSource() {
    _sortController.updateSortDelegate = () async => await loadMilestones();
    _filterController.applyFiltersDelegate = () async => loadMilestones();
    paginationController.loadDelegate = () async => await _getMilestones();
    paginationController.refreshDelegate =
        () async => await _getMilestones(needToClear: true);
    paginationController.pullDownEnabled = true;
  }

  Future loadMilestones() async {
    loaded.value = false;
    paginationController.startIndex = 0;
    await _getMilestones(needToClear: true);
    loaded.value = true;
  }

  Future _getMilestones({needToClear = false}) async {
    var result = await _api.milestonesByFilter(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectId: _projectId != null ? _projectId.toString() : null,
      milestoneResponsibleFilter: _filterController.milestoneResponsibleFilter,
      taskResponsibleFilter: _filterController.taskResponsibleFilter,
      statusFilter: _filterController.statusFilter,
      deadlineFilter: _filterController.deadlineFilter,
    );

    paginationController.total.value = result.length;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result);
  }

  Future<void> setup({ProjectDetailed projectDetailed, int projectId}) async {
    loaded.value = false;
    _projectDetailed = projectDetailed;
    _projectId = projectId ?? projectDetailed.id;
    _filterController.projectId = _projectId.toString();

    // ignore: unawaited_futures
    loadMilestones();

    await _userController.getUserInfo();
    _selfId ??= await _userController.getUserId();
    fabIsVisible.value = _canCreate();
    // (projectDetailed != null
    //         ? projectDetailed.responsible.id == _selfId || _canCreate()
    //         : _canCreate()) &&
    //     _projectDetailed?.status != ProjectStatusCode.closed.index;
  }

  bool _canCreate() => _projectDetailed.security['canCreateTask'];
  // _userController.user.isAdmin ||
  // _userController.user.isOwner ||
  // (_userController.user.listAdminModules != null &&
  //     _userController.user.listAdminModules.contains('projects'));
}
