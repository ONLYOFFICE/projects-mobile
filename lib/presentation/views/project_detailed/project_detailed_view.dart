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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/detailed_project_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_data_source.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_discussions_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_tasks_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_tab.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/views/project_detailed/project_edit_view.dart';
import 'package:projects/presentation/views/project_detailed/project_discussions_view.dart';
import 'package:projects/presentation/views/documents/entity_documents_view.dart';
import 'package:projects/presentation/views/project_detailed/project_milestones_view.dart';
import 'package:projects/presentation/views/project_detailed/project_overview.dart';
import 'package:projects/presentation/views/project_detailed/project_task_screen.dart';
import 'package:projects/presentation/views/project_detailed/project_team_view.dart';

class ProjectDetailedView extends StatefulWidget {
  ProjectDetailedView({Key? key}) : super(key: key);

  @override
  _ProjectDetailedViewState createState() => _ProjectDetailedViewState();
}

class ProjectDetailedTabs {
  static const overview = 0;
  static const tasks = 1;
  static const milestones = 2;
  static const discussions = 3;
  static const documents = 4;
  static const team = 5;
}

class _ProjectDetailedViewState extends State<ProjectDetailedView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final _activeIndex = 0.obs;

  final projectController = Get.find<ProjectDetailsController>();
  final documentsController = Get.find<DocumentsController>();
  final projectTasksController = Get.find<ProjectTasksController>();
  final projectMilestonesController = Get.find<MilestonesDataSource>();
  final projectDiscussionsController =
      Get.put<ProjectDiscussionsController>(ProjectDiscussionsController());
  final projectDocumentsController = Get.find<DocumentsController>();

  final projectDetailed = Get.arguments['projectDetailed'] as ProjectDetailed;

  @override
  void initState() {
    projectController.setup(projectDetailed);
    projectTasksController.setup(projectDetailed);
    projectMilestonesController.setup(projectDetailed: projectDetailed);
    projectDiscussionsController.setup(projectDetailed: projectDetailed);
    projectDocumentsController.setupFolder(
        folderName: projectDetailed.title!, folderId: projectDetailed.projectFolder);

    _tabController = TabController(
      vsync: this,
      length: 6,
    );

    _tabController!.addListener(() {
      if (_activeIndex.value == _tabController!.index) return;

      _activeIndex.value = _tabController!.index;
    });

    super.initState();
  }

  @override
  void dispose() {
    locator<EventHub>().fire('needToRefreshProjects', ['all']);
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyledAppBar(
        actions: [
          Obx(() {
            if (_activeIndex.value == ProjectDetailedTabs.tasks)
              return ProjectTasksSortButton(
                controller: projectTasksController,
              );

            if (_activeIndex.value == ProjectDetailedTabs.milestones)
              return ProjectMilestonesSortButton(controller: projectMilestonesController);

            return const SizedBox();
          }),
          if (!(projectController.projectData.security!['isInTeam'] as bool) ||
              projectController.projectData.canDelete!)
            _ProjectContextMenu(controller: projectController)
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
                      currentTab: _activeIndex.value == 1,
                      count: projectTasksController.tasksList.length),
                  CustomTab(
                      title: tr('milestones'),
                      currentTab: _activeIndex.value == 2,
                      count: projectMilestonesController.itemList.length),
                  CustomTab(
                      title: tr('discussions'),
                      currentTab: _activeIndex.value == 3,
                      count: projectDiscussionsController.itemList.length),
                  CustomTab(
                      title: tr('documents'),
                      currentTab: _activeIndex.value == 4,
                      count: projectDocumentsController.filesCount.value),
                  CustomTab(
                      title: tr('team'),
                      currentTab: _activeIndex.value == 5,
                      count: projectController.projectData.participantCount),
                ]),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProjectOverview(projectController: projectController, tabController: _tabController),
          ProjectTaskScreen(projectTasksController: projectTasksController),
          ProjectMilestonesScreen(
            controller: projectMilestonesController,
          ),
          ProjectDiscussionsScreen(controller: projectDiscussionsController),
          EntityDocumentsView(
            folderId: projectController.projectData.projectFolder,
            folderName: projectController.projectData.title,
            documentsController: projectDocumentsController,
          ),
          ProjectTeamView(
              projectDetailed: projectController.projectData,
              fabAction: projectController.manageTeamMembers),
        ],
      ),
    );
  }
}

class _ProjectContextMenu extends StatelessWidget {
  final ProjectDetailsController controller;

  const _ProjectContextMenu({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(PlatformIcons(context).ellipsis, size: 26),
      offset: const Offset(0, 25),
      onSelected: (dynamic value) => _onSelected(value, controller, context),
      itemBuilder: (context) {
        return [
          // const PopupMenuItem(value: 'copyLink', child: Text('Copy link')),
          if (controller.projectData.canEdit!)
            PopupMenuItem(
              value: 'edit',
              child: Text(tr('editProject')),
            ),
          if (!(controller.projectData.security?['isInTeam'] as bool))
            PopupMenuItem(
              value: 'follow',
              child: controller.projectData.isFollow as bool
                  ? Text(tr('unFollowProjectButton'))
                  : Text(tr('followProjectButton')),
            ),
          if (controller.projectData.canDelete as bool)
            PopupMenuItem(
              textStyle: Get.theme.popupMenuTheme.textStyle
                  ?.copyWith(color: Get.theme.colors().colorError),
              value: 'delete',
              child: Text(
                tr('delete'),
                style: TextStyleHelper.subtitle1(color: Get.theme.colors().colorError),
              ),
            )
        ];
      },
    );
  }
}

Future<void> _onSelected(value, controller, BuildContext context) async {
  switch (value) {
    case 'copyLink':
      controller.copyLink();
      break;

    case 'edit':
      Get.find<NavigationController>().to(
          EditProjectView(projectDetailed: controller.projectData as ProjectDetailed),
          arguments: {'projectDetailed': controller.projectData});
      break;

    case 'follow':
      controller.followProject();
      break;

    case 'delete':
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
            print('ERROR');
          }
        },
      ));
      break;
    default:
  }
}
