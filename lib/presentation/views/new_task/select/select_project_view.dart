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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/new_milestone_controller.dart';
import 'package:projects/domain/controllers/projects/project_search_controller.dart';
import 'package:projects/domain/controllers/projects/projects_with_presets.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';

class SelectProjectView extends StatelessWidget {
  const SelectProjectView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.arguments['controller'];

    final projectsWithPresets = locator<ProjectsWithPresets>();

    var projectsController = projectsWithPresets.myProjectsController;

    final userController = Get.find<UserController>();

    if (userController.user.value != null &&
        (userController.user.value!.isAdmin! ||
            userController.user.value!.isOwner! ||
            (userController.user.value!.listAdminModules != null &&
                userController.user.value!.listAdminModules!.contains('projects')))) {
      projectsController = projectsWithPresets.activeProjectsController;
    } else if (controller is NewTaskController || controller is DiscussionActionsController) {
      projectsController = projectsWithPresets.myMembershipProjectController;
    } else if (controller is NewMilestoneController) {
      projectsController = projectsWithPresets.myManagedProjectController;
    }

    final searchController = Get.put(ProjectSearchController(onlyMyProjects: true));

    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
        titleText: tr('selectProject'),
        // centerTitle: true,
        backButtonIcon: Icon(PlatformIcons(context).back),
        bottomHeight: 44,
        bottom: SearchField(
          hintText: tr('searchProjects'),
          controller: searchController.searchInputController,
          showClearIcon: true,
          onChanged: searchController.newSearch,
          onSubmitted: searchController.newSearch,
          onClearPressed: searchController.clearSearch,
        ),
      ),
      body: Obx(() {
        final scrollController = ScrollController();

        if (searchController.switchToSearchView.value == true &&
            searchController.searchResult.isNotEmpty) {
          return StyledSmartRefresher(
            scrollController: scrollController,
            enablePullDown: false,
            enablePullUp: searchController.pullUpEnabled,
            controller: searchController.refreshController,
            onLoading: searchController.onLoading,
            child: ListView.separated(
              controller: scrollController,
              itemCount: searchController.searchResult.length,
              separatorBuilder: (BuildContext context, int index) {
                return const StyledDivider(leftPadding: 16, rightPadding: 16);
              },
              itemBuilder: (c, i) =>
                  _ProjectCell(item: searchController.searchResult[i], controller: controller),
            ),
          );
        }
        if (searchController.switchToSearchView.value == true &&
            searchController.searchResult.isEmpty &&
            searchController.loaded.value == true) {
          return const NothingFound();
        }
        if (projectsController.loaded.value == true &&
            searchController.switchToSearchView.value == false) {
          return PaginationListView(
            scrollController: scrollController,
            paginationController: projectsController.paginationController,
            child: ListView.separated(
              controller: scrollController,
              itemCount: projectsController.paginationController.data.length,
              separatorBuilder: (BuildContext context, int index) {
                return const StyledDivider(leftPadding: 16, rightPadding: 16);
              },
              itemBuilder: (c, i) => _ProjectCell(
                  item: projectsController.paginationController.data[i], controller: controller),
            ),
          );
        }
        return const ListLoadingSkeleton();
      }),
    );
  }
}

class _ProjectCell extends StatelessWidget {
  const _ProjectCell({Key? key, required this.item, required this.controller}) : super(key: key);
  final ProjectDetailed item;
  final controller;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Get.find<PlatformController>().isMobile
          ? Get.theme.colors().backgroundColor
          : Get.theme.colors().surface,
      child: InkWell(
        onTap: () {
          controller.changeProjectSelection(item);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title!,
                      style: TextStyleHelper.subtitle1(),
                    ),
                    Text(item.responsible!.displayName!,
                        style: TextStyleHelper.caption(
                                color: Get.theme.colors().onSurface.withOpacity(0.6))
                            .copyWith(height: 1.667)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
