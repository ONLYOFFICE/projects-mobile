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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/detailed_project_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/context_menu/platform_context_menu_button.dart';
import 'package:projects/presentation/shared/widgets/context_menu/platform_context_menu_divider.dart';
import 'package:projects/presentation/shared/widgets/context_menu/platform_context_menu_item.dart';
import 'package:projects/presentation/shared/widgets/custom_tab.dart';
import 'package:projects/presentation/shared/widgets/search_button.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/discussions/discussions_shared.dart';
import 'package:projects/presentation/views/documents/documents_shared.dart';
import 'package:projects/presentation/views/project_detailed/project_discussions_view.dart';
import 'package:projects/presentation/views/project_detailed/project_documents_view.dart';
import 'package:projects/presentation/views/project_detailed/project_edit_view.dart';
import 'package:projects/presentation/views/project_detailed/project_milestones_view.dart';
import 'package:projects/presentation/views/project_detailed/project_overview.dart';
import 'package:projects/presentation/views/project_detailed/project_task_screen.dart';
import 'package:projects/presentation/views/project_detailed/project_team_view.dart';
import 'package:projects/presentation/views/tasks/tasks_shared.dart';

class ProjectDetailedTabs {
  static const overview = 0;
  static const tasks = 1;
  static const milestones = 2;
  static const discussions = 3;
  static const documents = 4;
  static const team = 5;

  static const length = 6;
}

class PopupMenuItemValue {
  static const editProject = 'editProject';
  static const followProject = 'followProject';
  static const deleteProject = 'deleteProject';
  static const sortTasks = 'sortTasks';
  static const sortMilestones = 'sortMilestones';
  static const sortDiscussions = 'sortDiscussions';
  static const sortDocuments = 'sortDocuments';
}

class ProjectDetailedView extends StatefulWidget {
  ProjectDetailedView({Key? key}) : super(key: key);

  @override
  _ProjectDetailedViewState createState() => _ProjectDetailedViewState();
}

class _ProjectDetailedViewState extends State<ProjectDetailedView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _activeIndex = ProjectDetailedTabs.tasks.obs;

  late final ProjectDetailsController projectController;
  String? previousPage;

  @override
  void initState() {
    if (Get.arguments['projectController'] != null)
      projectController = Get.arguments['projectController'] as ProjectDetailsController;
    else {
      final projectDetails = Get.arguments['projectDetailed'] as ProjectDetailed;

      projectController = Get.put<ProjectDetailsController>(
        ProjectDetailsController(),
        tag: projectDetails.id.toString(),
      );
      projectController.fillProjectInfo(projectDetails);
    }

    previousPage = Get.arguments['previousPage'] as String?;

    projectController.setup();

    _tabController = TabController(
      initialIndex: _activeIndex.value,
      vsync: this,
      length: ProjectDetailedTabs.length,
    );

    _tabController.addListener(() {
      if (_activeIndex.value == _tabController.index) return;

      _activeIndex.value = _tabController.index;
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyledAppBar(
        previousPageTitle: previousPage,
        actions: [
          Obx(
            () => _ProjectAppBarActions(
              projectController: projectController,
              index: _activeIndex.value,
            ),
          ),
          Obx(
            () => _ProjectContextMenu(
              controller: projectController,
              index: _activeIndex.value,
            ),
          ),
          if (GetPlatform.isIOS) const SizedBox(width: 6),
        ],
        bottom: SizedBox(
          height: 40,
          child: Obx(
            () => TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor: Theme.of(context).colors().primary,
                labelColor: Theme.of(context).colors().onSurface,
                unselectedLabelColor: Theme.of(context).colors().onSurface.withOpacity(0.6),
                labelStyle: TextStyleHelper.subtitle2(),
                tabs: [
                  Tab(text: tr('overview')),
                  CustomTab(
                      title: tr('tasks'),
                      currentTab: _activeIndex.value == ProjectDetailedTabs.tasks,
                      count: projectController.taskCount.value),
                  CustomTab(
                      title: tr('milestones'),
                      currentTab: _activeIndex.value == ProjectDetailedTabs.milestones,
                      count: projectController.milestoneCount.value),
                  CustomTab(
                      title: tr('discussions'),
                      currentTab: _activeIndex.value == ProjectDetailedTabs.discussions,
                      count: projectController.discussionCount.value),
                  CustomTab(
                      title: tr('documents'),
                      currentTab: _activeIndex.value == ProjectDetailedTabs.documents,
                      count: projectController.projectDocumentsController?.filesCount.value ?? 0),
                  CustomTab(
                      title: tr('team'),
                      currentTab: _activeIndex.value == ProjectDetailedTabs.team,
                      count: projectController.projectTeamDataSource?.usersList.length ?? 0),
                ]),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProjectOverview(projectController: projectController, tabController: _tabController),
          ProjectTaskScreen(projectTasksController: projectController.projectTasksController!),
          ProjectMilestonesScreen(controller: projectController.projectMilestonesController!),
          ProjectDiscussionsScreen(controller: projectController.projectDiscussionsController!),
          ProjectDocumentsScreen(controller: projectController.projectDocumentsController!),
          ProjectTeamView(
              projectTeamDataSource: projectController.projectTeamDataSource!,
              fabAction: projectController.manageTeamMembers),
        ],
      ),
    );
  }
}

class _ProjectAppBarActions extends StatelessWidget {
  final ProjectDetailsController projectController;
  final int index;

  const _ProjectAppBarActions({Key? key, required this.projectController, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return () {
      if (index == ProjectDetailedTabs.tasks && projectController.projectTasksController != null)
        return Row(
          children: [
            SearchButton(controller: projectController.projectTasksController!),
            TasksFilterButton(controller: projectController.projectTasksController!),
          ],
        );

      if (index == ProjectDetailedTabs.milestones &&
          projectController.projectMilestonesController != null)
        return Row(
          children: [
            SearchButton(controller: projectController.projectMilestonesController!),
            ProjectMilestonesFilterButton(
                controller: projectController.projectMilestonesController!)
          ],
        );

      if (index == ProjectDetailedTabs.discussions &&
          projectController.projectDiscussionsController != null)
        return Row(
          children: [
            SearchButton(controller: projectController.projectDiscussionsController!),
            DiscussionsFilterButton(controller: projectController.projectDiscussionsController!)
          ],
        );

      if (index == ProjectDetailedTabs.documents &&
          projectController.projectDocumentsController != null)
        return Row(
          children: [
            SearchButton(controller: projectController.projectDocumentsController!),
            DocumentsFilterButton(controller: projectController.projectDocumentsController!),
          ],
        );

      return const SizedBox();
    }();
  }
}

class _ProjectContextMenu extends StatelessWidget {
  final ProjectDetailsController controller;
  final int index;

  const _ProjectContextMenu({Key? key, required this.controller, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformPopupMenuButton(
      padding: EdgeInsets.zero,
      icon: PlatformIconButton(
        padding: EdgeInsets.zero,
        cupertinoIcon: Icon(
          CupertinoIcons.ellipsis_circle,
          color: Theme.of(context).colors().primary,
        ),
        materialIcon: Icon(
          Icons.more_vert,
          color: Theme.of(context).colors().primary,
        ),
        cupertino: (_, __) => CupertinoIconButtonData(minSize: 36),
      ),
      onSelected: (value) => _onSelected(value as String, controller, context),
      itemBuilder: (context) {
        final items = getSortTiles();
        final projectTiles = getProjectTiles();

        if (items.isNotEmpty && projectTiles.isNotEmpty)
          items.add(const PlatformPopupMenuDivider());

        return items + projectTiles;
      },
    );
  }

  List<PopupMenuEntry<dynamic>> getSortTiles() {
    return [
      if (index == ProjectDetailedTabs.tasks &&
          controller.projectTasksController != null &&
          controller.projectTasksController!.itemList.isNotEmpty)
        for (final tile in controller.projectTasksController!.sortController.getSortTile())
          PlatformPopupMenuItem(
            onTap: () {
              tile.sortController.changeSort(tile.sortParameter);
              Get.back();
            },
            child: tile,
          ),
      if (index == ProjectDetailedTabs.milestones &&
          controller.projectMilestonesController != null &&
          controller.projectMilestonesController!.itemList.isNotEmpty)
        for (final tile in controller.projectMilestonesController!.sortController.getSortTile())
          PlatformPopupMenuItem(
            onTap: () {
              tile.sortController.changeSort(tile.sortParameter);
              Get.back();
            },
            child: tile,
          ),
      if (index == ProjectDetailedTabs.discussions &&
          controller.projectDiscussionsController != null &&
          controller.projectDiscussionsController!.itemList.isNotEmpty)
        for (final tile in controller.projectDiscussionsController!.sortController.getSortTile())
          PlatformPopupMenuItem(
            onTap: () {
              tile.sortController.changeSort(tile.sortParameter);
              Get.back();
            },
            child: tile,
          ),
      if (index == ProjectDetailedTabs.documents &&
          controller.projectDocumentsController != null &&
          controller.projectDocumentsController!.itemList.isNotEmpty)
        for (final tile in controller.projectDocumentsController!.sortController.getSortTile())
          PlatformPopupMenuItem(
            onTap: () {
              tile.sortController.changeSort(tile.sortParameter);
              Get.back();
            },
            child: tile,
          ),
    ];
  }

  List<PopupMenuEntry<dynamic>> getProjectTiles() {
    return [
      if (controller.projectData.canEdit!)
        PlatformPopupMenuItem(
          value: PopupMenuItemValue.editProject,
          child: Text(tr('editProject')),
        ),
      if (!(controller.projectData.security?['isInTeam'] as bool))
        PlatformPopupMenuItem(
          onTap: () {
            controller.followProject();
            Get.back();
          },
          child: controller.projectData.isFollow == true
              ? Text(tr('unFollowProjectButton'))
              : Text(tr('followProjectButton')),
        ),
      if (controller.projectData.canDelete as bool)
        PlatformPopupMenuItem(
          textStyle: TextStyleHelper.subtitle1(color: Theme.of(Get.context!).colors().colorError),
          value: PopupMenuItemValue.deleteProject,
          isDestructiveAction: true,
          child: Text(tr('delete')),
        ),
    ];
  }
}

Future<void> _onSelected(
    String value, ProjectDetailsController controller, BuildContext context) async {
  switch (value) {
    case PopupMenuItemValue.editProject:
      unawaited(
        Get.find<NavigationController>().toScreen(
          const EditProjectView(),
          transition: GetPlatform.isAndroid ? Transition.downToUp : Transition.cupertinoDialog,
          fullscreenDialog: true,
          arguments: {'projectDetailed': controller.projectData},
          page: '/EditProjectView',
        ),
      );
      break;

    case PopupMenuItemValue.deleteProject:
      await Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('deleteProject'),
        contentText: tr('deleteProjectAlert'),
        acceptText: tr('delete').toUpperCase(),
        acceptColor: Theme.of(context).colors().colorError,
        onCancelTap: () async => Get.back(),
        onAcceptTap: () async {
          final result = await controller.deleteProject();
          if (result) {
            Get.back();
            Get.back();

            MessagesHandler.showSnackBar(context: context, text: tr('projectDeleted'));

            locator<EventHub>().fire('needToRefreshProjects', {'all': true});
            locator<EventHub>().fire('needToRefreshTasks', {'all': true});
            locator<EventHub>().fire('needToRefreshDiscussions', {'all': true});
            locator<EventHub>().fire('needToRefreshDocuments', {'all': true});
          } else
            MessagesHandler.showSnackBar(context: context, text: tr('error'));
        },
      ));
      break;
    default:
  }
}
