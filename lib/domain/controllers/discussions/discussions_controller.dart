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
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_filter_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_sort_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/projects_with_presets.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/new_discussion/new_discussion_screen.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_detailed.dart';
import 'package:projects/presentation/views/discussions/discussions_search_view.dart';

class DiscussionsController extends BaseController {
  final _api = locator<DiscussionsService>();

  PaginationController _paginationController;
  PaginationController get paginationController => _paginationController;

  final _userController = Get.find<UserController>();
  final _sortController = Get.find<DiscussionsSortController>();
  DiscussionsSortController get sortController => _sortController;

  DiscussionsFilterController _filterController;
  DiscussionsFilterController get filterController => _filterController;

  RxBool loaded = false.obs;
  var fabIsVisible = true.obs;

  DiscussionsController(
    DiscussionsFilterController filterController,
    PaginationController paginationController,
  ) {
    screenName = tr('discussions');
    _paginationController = paginationController;
    _filterController = filterController;
    _filterController.applyFiltersDelegate = () async => loadDiscussions();
    _sortController.updateSortDelegate = () async => await loadDiscussions();
    paginationController.loadDelegate = () async => await _getDiscussions();
    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;

    getFabVisibility().then((value) => fabIsVisible.value = value);

    locator<EventHub>().on('moreViewVisibilityChanged', (dynamic data) async {
      fabIsVisible.value = data ? false : await getFabVisibility();
    });
  }

  @override
  RxList get itemList => paginationController.data;

  Future loadDiscussions({PresetDiscussionFilters preset}) async {
    loaded.value = false;
    paginationController.startIndex = 0;
    if (preset != null) {
      await _filterController
          .setupPreset(preset)
          .then((value) => _getDiscussions(needToClear: true));
    } else {
      await _getDiscussions(needToClear: true);
    }
    loaded.value = true;
  }

  Future<void> refreshData() async {
    loaded.value = false;
    await _getDiscussions(needToClear: true);
    loaded.value = true;
  }

  Future _getDiscussions({needToClear = false, String projectId}) async {
    var result = await _api.getDiscussionsByParams(
      startIndex: paginationController.startIndex,
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      authorFilter: _filterController.authorFilter,
      statusFilter: _filterController.statusFilter,
      creationDateFilter: _filterController.creationDateFilter,
      projectFilter: _filterController.projectFilter,
      otherFilter: _filterController.otherFilter,
      projectId: projectId,
    );
    paginationController.total.value = result.total;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response);
  }

  void toDetailed(Discussion discussion) => Get.find<NavigationController>()
      .to(DiscussionDetailed(), arguments: {'discussion': discussion});

  void toNewDiscussionScreen() =>
      Get.find<NavigationController>().to(const NewDiscussionScreen());

  @override
  void showSearch() =>
      Get.find<NavigationController>().to(const DiscussionsSearchScreen());

  Future<bool> getFabVisibility() async {
    var fabVisibility =
        ProjectsWithPresets.myProjectsController.itemList.isNotEmpty;
    await _userController.getUserInfo();
    var selfUser = _userController.user;

    if (selfUser.isAdmin ||
        selfUser.isOwner ||
        selfUser.listAdminModules.contains('projects')) {
      fabVisibility =
          ProjectsWithPresets.activeProjectsController.itemList.isNotEmpty;
    }
    return fabVisibility;
  }
}
