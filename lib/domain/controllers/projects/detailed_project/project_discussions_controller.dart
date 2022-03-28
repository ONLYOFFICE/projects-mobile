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

import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/data/services/project_service.dart';

import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';

import 'package:projects/domain/controllers/discussions/base_discussions_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_filter_controller.dart';

import 'package:projects/domain/controllers/discussions/discussions_sort_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/new_discussion/new_discussion_screen.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_detailed.dart';
import 'package:projects/presentation/views/discussions/discussions_search_view.dart';

class ProjectDiscussionsController extends BaseDiscussionsController {
  final DiscussionsService _api = locator<DiscussionsService>();

  int? projectId;
  String? projectTitle;

  @override
  RxList<Discussion> get itemList => paginationController.data;
  @override
  PaginationController<Discussion> get paginationController => _paginationController;
  final _paginationController = PaginationController<Discussion>();

  late ProjectDetailed _projectDetailed;

  final _sortController = DiscussionsSortController();
  @override
  DiscussionsSortController get sortController => _sortController;

  final _filterController = Get.find<DiscussionsFilterController>();
  @override
  DiscussionsFilterController get filterController => _filterController;

  final fabIsVisible = false.obs;

  late StreamSubscription _refreshDiscussionsSubscription;
  late StreamSubscription _refreshDetailsSubscription;

  ProjectDiscussionsController() {
    _sortController.updateSortDelegate = () async => await loadProjectDiscussions();
    _filterController.applyFiltersDelegate = () async => loadProjectDiscussions();

    _paginationController.loadDelegate = () async => await _getDiscussions();
    _paginationController.refreshDelegate = () async => await loadProjectDiscussions();
    _paginationController.pullDownEnabled = true;

    _refreshDiscussionsSubscription =
        locator<EventHub>().on('needToRefreshDiscussions', (dynamic data) async {
      await loadProjectDiscussions();
    });

    _refreshDetailsSubscription = locator<EventHub>().on('needToRefreshProjects', (dynamic data) {
      if (data['projectDetails'].id == null || data['projectDetails'].id != _projectDetailed.id)
        return;

      _projectDetailed = data['projectDetails'] as ProjectDetailed;
      fabIsVisible.value = _canCreate();
    });
  }

  @override
  void onClose() {
    _refreshDiscussionsSubscription.cancel();
    _refreshDetailsSubscription.cancel();
    super.onClose();
  }

  void setup(ProjectDetailed projectDetailed) {
    _projectDetailed = projectDetailed;
    projectId = projectDetailed.id;
    _filterController.projectId = projectId!.toString();
    projectTitle = projectDetailed.title;
    fabIsVisible.value = _canCreate();

    loadProjectDiscussions();
  }

  bool _canCreate() => _projectDetailed.security?['canCreateMessage'] ?? false;

  Future loadProjectDiscussions({PresetDiscussionFilters? preset}) async {
    loaded.value = false;

    unawaited(updateDetails());
    _paginationController.startIndex = 0;
    if (preset != null) await _filterController.setupPreset(preset);

    await _getDiscussions(needToClear: true);

    loaded.value = true;
  }

  Future<bool> _getDiscussions({bool needToClear = false}) async {
    final result = await _api.getDiscussionsByParams(
      startIndex: _paginationController.startIndex,
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      authorFilter: _filterController.authorFilter,
      statusFilter: _filterController.statusFilter,
      creationDateFilter: _filterController.creationDateFilter,
      projectFilter: _filterController.projectFilter,
      otherFilter: _filterController.otherFilter,
      projectId: projectId.toString(),
    );
    if (result == null) return Future.value(false);

    _paginationController.total.value = result.total;
    if (needToClear) _paginationController.data.clear();
    _paginationController.data.addAll(result.response ?? <Discussion>[]);

    return Future.value(true);
  }

  @override
  void toDetailed(DiscussionItemController discussionItemController) =>
      Get.find<NavigationController>()
          .to(DiscussionDetailed(), arguments: {'controller': discussionItemController});

  void toNewDiscussionScreen() =>
      Get.find<NavigationController>().toScreen(const NewDiscussionScreen(),
          arguments: {'projectId': projectId, 'projectTitle': projectTitle},
          transition: Transition.cupertinoDialog,
          fullscreenDialog: true);

  @override
  void showSearch() =>
      Get.find<NavigationController>().to(const DiscussionsSearchScreen(), arguments: {
        'projectId': projectId,
        'discussionsFilterController': filterController,
        'discussionsSortController': sortController
      });

  Future<void> updateDetails() async {
    // TODO change to needToRefreshProjects updateID ...
    final response =
        await locator<ProjectService>().getProjectById(projectId: _projectDetailed.id!);
    if (response == null) return;

    _projectDetailed = response;
    fabIsVisible.value = _canCreate();

    locator<EventHub>().fire('needToRefreshProjects', {'projectDetails': response});
  }
}
