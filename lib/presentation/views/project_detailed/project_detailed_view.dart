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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/detailed_project_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_tab.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_item.dart';
import 'package:projects/presentation/shared/wrappers/platform_widget.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';
import 'package:projects/presentation/views/project_detailed/project_discussions_view.dart';
import 'package:projects/presentation/views/project_detailed/project_documents_view.dart';
import 'package:projects/presentation/views/project_detailed/project_edit_view.dart';
import 'package:projects/presentation/views/project_detailed/project_milestones_view.dart';
import 'package:projects/presentation/views/project_detailed/project_overview.dart';
import 'package:projects/presentation/views/project_detailed/project_task_screen.dart';
import 'package:projects/presentation/views/project_detailed/project_team_view.dart';

class ProjectDetailedTabs {
  static const overview = 0;
  static const tasks = 1;
  static const milestones = 2;
  static const discussions = 3;
  static const documents = 4;
  static const team = 5;
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
  late TabController _tabController;

  final _activeIndex = 0.obs;

  final projectController = Get.find<ProjectDetailsController>();

  @override
  void initState() {
    projectController.setup(Get.arguments['projectDetailed'] as ProjectDetailed);

    _tabController = TabController(
      vsync: this,
      length: 6,
    );

    _tabController.addListener(() {
      if (_activeIndex.value == _tabController.index) return;

      _activeIndex.value = _tabController.index;
    });

    super.initState();
  }

  @override
  void dispose() {
    locator<EventHub>().fire('needToRefreshProjects', ['all']);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyledAppBar(
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
          )
        ],
        bottom: SizedBox(
          height: 40,
          child: Obx(
            () => TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor: Get.theme.colors().primary,
                labelColor: Get.theme.colors().onSurface,
                unselectedLabelColor: Get.theme.colors().onSurface.withOpacity(0.6),
                labelStyle: TextStyleHelper.subtitle2(),
                tabs: [
                  Tab(text: tr('overview')),
                  CustomTab(
                      title: tr('tasks'),
                      currentTab: _activeIndex.value == ProjectDetailedTabs.tasks,
                      count: projectController.projectTasksController.tasksList.length),
                  CustomTab(
                      title: tr('milestones'),
                      currentTab: _activeIndex.value == ProjectDetailedTabs.milestones,
                      count: projectController.projectMilestonesController.itemList.length),
                  CustomTab(
                      title: tr('discussions'),
                      currentTab: _activeIndex.value == ProjectDetailedTabs.discussions,
                      count: projectController.projectDiscussionsController.itemList.length),
                  CustomTab(
                      title: tr('documents'),
                      currentTab: _activeIndex.value == ProjectDetailedTabs.documents,
                      count: projectController.projectDocumentsController.filesCount.value),
                  CustomTab(
                      title: tr('team'),
                      currentTab: _activeIndex.value == ProjectDetailedTabs.team,
                      count: projectController.projectData.participantCount),
                ]),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProjectOverview(projectController: projectController, tabController: _tabController),
          ProjectTaskScreen(projectTasksController: projectController.projectTasksController),
          ProjectMilestonesScreen(controller: projectController.projectMilestonesController),
          ProjectDiscussionsScreen(controller: projectController.projectDiscussionsController),
          ProjectDocumentsScreen(controller: projectController.projectDocumentsController),
          ProjectTeamView(
              projectTeamDataSource: projectController.projectTeamDataSource,
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
      if (index == ProjectDetailedTabs.tasks &&
          (projectController.projectTasksController.tasksList.isNotEmpty ||
              projectController.projectTasksController.filterController.hasFilters.value))
        return Row(
          children: [
            PlatformIconButton(
              icon: Icon(PlatformIcons(context).search),
              onPressed: projectController.projectTasksController.showSearch,
            ),
            ProjectTasksFilterButton(controller: projectController.projectTasksController),
          ],
        );

      if (index == ProjectDetailedTabs.milestones &&
          (projectController.projectMilestonesController.itemList.isNotEmpty ||
              projectController.projectMilestonesController.filterController.hasFilters.value))
        return Row(
          children: [
            PlatformIconButton(
              icon: Icon(PlatformIcons(context).search),
            ),
            ProjectMilestonesFilterButton(
                controller: projectController.projectMilestonesController),
          ],
        );

      if (index == ProjectDetailedTabs.discussions &&
          (projectController.projectDiscussionsController.itemList.isNotEmpty ||
              projectController.projectDiscussionsController.filterController.hasFilters.value))
        return Row(
          children: [
            PlatformIconButton(
              icon: Icon(PlatformIcons(context).search),
              onPressed: projectController.projectDiscussionsController.showSearch,
            ),
            ProjectDiscussionsFilterButton(
                controller: projectController.projectDiscussionsController)
          ],
        );

      if (index == ProjectDetailedTabs.documents &&
          (projectController.projectDocumentsController.itemList.isNotEmpty ||
              projectController.projectDocumentsController.filterController.hasFilters.value))
        return Row(
          children: [
            PlatformIconButton(
                icon: Icon(PlatformIcons(context).search),
                onPressed: () {
                  Get.find<NavigationController>()
                      .to(DocumentsSearchView(), preventDuplicates: false, arguments: {
                    'folderName': projectController.projectDocumentsController.screenName,
                    'folderId': projectController.projectDocumentsController.currentFolderID,
                    'documentsController': projectController.projectDocumentsController,
                  });
                }),
            ProjectDocumentsFilterButton(controller: projectController.projectDocumentsController),
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
      icon: PlatformWidget(
        cupertino: (_, __) => Icon(
          CupertinoIcons.ellipsis_circle,
          color: Get.theme.colors().primary,
          size: 26,
        ),
        material: (_, __) => const Icon(
          Icons.more_vert,
          size: 26,
        ),
      ),
      //offset: const Offset(0, 25),
      onSelected: (String value) => _onSelected(value, controller, context),
      itemBuilder: (context) {
        return [
          if (index == ProjectDetailedTabs.tasks &&
              (controller.projectTasksController.tasksList.isNotEmpty ||
                  controller.projectTasksController.filterController.hasFilters.value))
            PlatformPopupMenuItem(
                value: PopupMenuItemValue.sortTasks,
                child: ProjectTasksSortButton(
                  controller: controller.projectTasksController,
                )),
          if (index == ProjectDetailedTabs.milestones &&
              (controller.projectMilestonesController.itemList.isNotEmpty ||
                  controller.projectMilestonesController.filterController.hasFilters.value))
            PlatformPopupMenuItem(
                value: PopupMenuItemValue.sortMilestones,
                child: ProjectMilestonesSortButton(
                  controller: controller.projectMilestonesController,
                )),
          if (index == ProjectDetailedTabs.discussions &&
              (controller.projectDiscussionsController.itemList.isNotEmpty ||
                  controller.projectDiscussionsController.filterController.hasFilters.value))
            PlatformPopupMenuItem(
                value: PopupMenuItemValue.sortDiscussions,
                child: ProjectDiscussionsSortButton(
                  controller: controller.projectDiscussionsController,
                )),
          if (index == ProjectDetailedTabs.documents &&
              (controller.projectDocumentsController.itemList.isNotEmpty ||
                  controller.projectDocumentsController.filterController.hasFilters.value))
            PlatformPopupMenuItem(
                value: PopupMenuItemValue.sortDocuments,
                child: ProjectDocumentsSortButton(
                  controller: controller.projectDocumentsController,
                )),
          if (controller.projectData.canEdit!)
            PlatformPopupMenuItem(
              value: PopupMenuItemValue.editProject,
              child: Text(tr('editProject')),
            ),
          if (!(controller.projectData.security?['isInTeam'] as bool))
            PlatformPopupMenuItem(
              value: PopupMenuItemValue.followProject,
              child: controller.projectData.isFollow as bool
                  ? Text(tr('unFollowProjectButton'))
                  : Text(tr('followProjectButton')),
            ),
          if (controller.projectData.canDelete as bool)
            PlatformPopupMenuItem(
              textStyle: TextStyleHelper.subtitle1(color: Get.theme.colors().colorError),
              value: PopupMenuItemValue.deleteProject,
              isDestructiveAction: true,
              child: Text(tr('delete')),
            )
        ];
      },
    );
  }
}

Future<void> _onSelected(
    String value, ProjectDetailsController controller, BuildContext context) async {
  switch (value) {
    case 'copyLink':
      await controller.copyLink();
      break;

    case PopupMenuItemValue.sortTasks:
      taskSortButtonOnPressed(controller.projectTasksController, context);
      break;

    case PopupMenuItemValue.sortMilestones:
      milestonesSortButtonOnPressed(controller.projectMilestonesController, context);
      break;

    case PopupMenuItemValue.sortDiscussions:
      discussionsSortButtonOnPressed(controller.projectDiscussionsController, context);
      break;

    case PopupMenuItemValue.sortDocuments:
      documentsSortButtonOnPressed(controller.projectDocumentsController, context);
      break;

    case PopupMenuItemValue.editProject:
      Get.find<NavigationController>().to(EditProjectView(projectDetailed: controller.projectData),
          transition: GetPlatform.isAndroid ? Transition.downToUp : Transition.cupertinoDialog,
          fullscreenDialog: true,
          arguments: {'projectDetailed': controller.projectData});
      break;

    case PopupMenuItemValue.followProject:
      await controller.followProject();
      break;

    case PopupMenuItemValue.deleteProject:
      await Get.dialog(StyledAlertDialog(
        titleText: tr('deleteProject'),
        contentText: tr('deleteProjectAlert'),
        acceptText: tr('delete').toUpperCase(),
        onCancelTap: () async => Get.back(),
        onAcceptTap: () async {
          final result = await controller.deleteProject();
          if (result != null) {
            Get.back();
            Get.back();
            MessagesHandler.showSnackBar(
              context: context,
              text: tr('projectDeleted'),
            );
            locator<EventHub>().fire('needToRefreshProjects', ['all']);
          } else {
            MessagesHandler.showSnackBar(
              context: context,
              text: tr('error'),
            );
          }
        },
      ));
      break;
    default:
  }
}
