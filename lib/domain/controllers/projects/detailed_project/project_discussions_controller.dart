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
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';

import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/domain/controllers/discussions/discussions_sort_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/new_discussion/new_discussion_screen.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_detailed.dart';

class ProjectDiscussionsController extends GetxController {
  final DiscussionsService _api = locator<DiscussionsService>();
  var projectId;
  var projectTitle;

  final _paginationController =
      Get.put(PaginationController(), tag: 'ProjectDiscussionsController');

  late ProjectDetailed _projectDetailed;

  PaginationController get paginationController => _paginationController;

  final _sortController = Get.find<DiscussionsSortController>();

  RxBool loaded = false.obs;

  var fabIsVisible = false.obs;

  ProjectDiscussionsController(ProjectDetailed projectDetailed) {
    setup(projectDetailed);
    _sortController.updateSortDelegate = () async => await loadProjectDiscussions();

    paginationController.loadDelegate = () async => await _getDiscussions();
    paginationController.refreshDelegate = () async => await _getDiscussions(needToClear: true);
    paginationController.pullDownEnabled = true;
  }

  void setup(ProjectDetailed projectDetailed) {
    _projectDetailed = projectDetailed;
    projectId = projectDetailed.id;
    projectTitle = projectDetailed.title;

    fabIsVisible.value = _canCreate()!;
  }

  bool? _canCreate() => _projectDetailed.security!['canCreateMessage'];

  RxList get itemList => paginationController.data;

  Future loadProjectDiscussions() async {
    loaded.value = false;

    paginationController.startIndex = 0;
    await _getDiscussions(needToClear: true);

    loaded.value = true;
  }

  Future<bool> _getDiscussions({bool needToClear = false}) async {
    final result = await _api.getDiscussionsByParams(
      startIndex: paginationController.startIndex,
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectId: projectId.toString(),
    );

    if (result == null) return Future.value(false);

    paginationController.total.value = result.total;
    if (needToClear) paginationController.data.clear();
    paginationController.data.addAll(result.response ?? <Discussion>[]);

    return Future.value(true);
  }

  void toDetailed(Discussion discussion) => Get.find<NavigationController>()
      .to(DiscussionDetailed(), arguments: {'discussion': discussion});

  void toNewDiscussionScreen() => Get.find<NavigationController>().to(const NewDiscussionScreen(),
      arguments: {'projectId': projectId, 'projectTitle': projectTitle});
}
