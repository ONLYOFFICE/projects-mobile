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

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/domain/controllers/discussions/base_discussions_controller.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
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

class DiscussionsController extends BaseDiscussionsController {
  final DiscussionsService _api = locator<DiscussionsService>();
  final ProjectsWithPresets projectsWithPresets = locator<ProjectsWithPresets>();

  @override
  RxList get itemList => paginationController.data;
  final _paginationController = PaginationController<Discussion>();
  @override
  PaginationController get paginationController => _paginationController;

  final _sortController = DiscussionsSortController();
  @override
  DiscussionsSortController get sortController => _sortController;

  final _filterController = Get.find<DiscussionsFilterController>();
  @override
  DiscussionsFilterController get filterController => _filterController;

  final fabIsVisible = false.obs;

  final _ss = <StreamSubscription>[];

  DiscussionsController() {
    screenName = tr('discussions');

    _filterController.applyFiltersDelegate = () async => loadDiscussions();
    _sortController.updateSortDelegate = () async => loadDiscussions();

    paginationController.loadDelegate = () async => _getDiscussions();
    paginationController.refreshDelegate = () async => refreshData();
    paginationController.pullDownEnabled = true;

    getFabVisibility(false);
    _ss.add(Get.find<UserController>().dataUpdated.listen(getFabVisibility));

    _ss.add(Get.find<NavigationController>().onMoreView.listen((moreOpen) {
      if (moreOpen) {
        fabIsVisible.value = false;
        return;
      }

      getFabVisibility(false);
    }));

    _ss.add(locator<EventHub>().on('needToRefreshDiscussions', (dynamic data) async {
      if (data['all'] == true) {
        await loadDiscussions();
        return;
      }

      if (data['discussion'].id != null) {
        for (var i = 0; i < itemList.length; i++)
          if (itemList[i].id == data['discussion'].id) {
            itemList[i] = data['discussion'] as Discussion;
            return;
          }
      }
    }));
  }

  @override
  void onClose() {
    for (final element in _ss) {
      element.cancel();
    }

    super.onClose();
  }

  Future loadDiscussions({PresetDiscussionFilters? preset}) async {
    loaded.value = false;

    paginationController.startIndex = 0;
    if (preset != null) await _filterController.setupPreset(preset);

    await _getDiscussions(needToClear: true);

    loaded.value = true;
  }

  Future<void> refreshData() async {
    loaded.value = false;

    unawaited(Get.find<UserController>().updateData());
    await _getDiscussions(needToClear: true);

    loaded.value = true;
  }

  Future _getDiscussions({bool needToClear = false, String? projectId}) async {
    final result = await _api.getDiscussionsByParams(
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

    if (result == null) return Future.value(false);

    paginationController.total.value = result.total;
    if (needToClear) paginationController.data.clear();
    paginationController.data.addAll(result.response ?? <Discussion>[]);

    return Future.value(true);
  }

  @override
  void toDetailed(DiscussionItemController discussionItemController) =>
      Get.find<NavigationController>()
          .to(DiscussionDetailed(), arguments: {'controller': discussionItemController});

  void toNewDiscussionScreen() => Get.find<NavigationController>().toScreen(
        const NewDiscussionScreen(),
        transition: Transition.cupertinoDialog,
        fullscreenDialog: true,
        page: '/NewDiscussionScreen',
      );

  @override
  void showSearch() =>
      Get.find<NavigationController>().to(const DiscussionsSearchScreen(), arguments: {
        'discussionsFilterController': filterController,
        'discussionsSortController': sortController
      });

  void getFabVisibility(bool _) {
    if (Get.find<NavigationController>().onMoreView.value) {
      fabIsVisible.value = false;
      return;
    }

    final user = Get.find<UserController>().user.value;
    final info = Get.find<UserController>().securityInfo.value;

    if (user == null || info == null) return;

    if ((user.isAdmin ?? false) ||
        (user.isOwner ?? false) ||
        (user.listAdminModules != null && user.listAdminModules!.contains('projects')) ||
        (info.canCreateMessage ?? false))
      fabIsVisible.value = true;
    else
      fabIsVisible.value = false;
  }
}
