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
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/detailed_project_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_discussions_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_tab.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/project_detailed/project_edit_view.dart';
import 'package:projects/presentation/views/project_detailed/project_discussions_view.dart';
import 'package:projects/presentation/views/documents/entity_documents_view.dart';
import 'package:projects/presentation/views/project_detailed/milestones/project_milestones_view.dart';
import 'package:projects/presentation/views/project_detailed/project_overview.dart';
import 'package:projects/presentation/views/project_detailed/project_task_screen.dart';
import 'package:projects/presentation/views/project_detailed/project_team_view.dart';

class ProjectDetailedView extends StatefulWidget {
  ProjectDetailedView({Key key}) : super(key: key);

  @override
  _ProjectDetailedViewState createState() => _ProjectDetailedViewState();
}

class _ProjectDetailedViewState extends State<ProjectDetailedView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  // ignore: prefer_final_fields
  RxInt _activeIndex = 0.obs;

  ProjectDetailed projectDetailed = Get.arguments['projectDetailed'];

  var projectController;
  var discussionsController;
  final documentsController = Get.find<DocumentsController>();

  @override
  void initState() {
    super.initState();

    discussionsController = Get.put(ProjectDiscussionsController(
        projectDetailed.id, projectDetailed.title));

    projectController =
        Get.put(ProjectDetailsController(Get.arguments['projectDetailed']));

    projectController.setup();

    documentsController.setupFolder(
        folderName: projectDetailed.title,
        folderId: projectDetailed.projectFolder);

    _tabController = TabController(
      vsync: this,
      length: 6,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() {
      if (_activeIndex.value == _tabController.index) return;

      _activeIndex.value = _tabController.index;
    });

    return Obx(
      () => Scaffold(
        floatingActionButton: Visibility(
          visible: _activeIndex.value == 2 || _activeIndex.value == 1,
          child: StyledFloatingActionButton(
            onPressed: () {
              if (_activeIndex.value == 2)
                projectController.createNewMilestone();
              if (_activeIndex.value == 1) projectController.createTask();
            },
            child: _activeIndex.value == 2
                ? AppIcon(
                    icon: SvgIcons.add_milestone,
                    width: 32,
                    height: 32,
                  )
                : const Icon(Icons.add_rounded),
          ),
        ),
        appBar: StyledAppBar(
          actions: [
            projectDetailed.canEdit
                ? IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => Get.find<NavigationController>().to(
                        EditProjectView(projectDetailed: projectDetailed),
                        arguments: {'projectDetailed': projectDetailed}))
                : const SizedBox(),
            _ProjectContextMenu(controller: projectController)
          ],
          bottom: SizedBox(
            height: 40,
            child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor: Get.theme.colors().primary,
                labelColor: Get.theme.colors().onSurface,
                unselectedLabelColor:
                    Get.theme.colors().onSurface.withOpacity(0.6),
                labelStyle: TextStyleHelper.subtitle2(),
                tabs: [
                  Tab(text: tr('overview')),
                  CustomTab(
                      title: tr('tasks'),
                      currentTab: _activeIndex.value == 1,
                      count: projectController.projectDetailed.taskCountTotal),
                  CustomTab(
                      title: tr('milestones'),
                      currentTab: _activeIndex.value == 2,
                      count: projectController.milestoneCount.value),
                  CustomTab(
                      title: tr('discussions'),
                      currentTab: _activeIndex.value == 3,
                      count: projectController.projectDetailed.discussionCount),
                  CustomTab(
                      title: tr('documents'),
                      currentTab: _activeIndex.value == 4,
                      count: projectController.docsCount.value),
                  CustomTab(
                      title: tr('team'),
                      currentTab: _activeIndex.value == 5,
                      count:
                          projectController.projectDetailed.participantCount),
                ]),
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          ProjectOverview(
              projectDetailed: projectDetailed, tabController: _tabController),
          ProjectTaskScreen(projectDetailed: projectDetailed),
          ProjectMilestonesScreen(projectDetailed: projectDetailed),
          ProjectDiscussionsScreen(controller: discussionsController),
          EntityDocumentsView(
            folderId: projectDetailed.projectFolder,
            folderName: projectDetailed.title,
            documentsController: documentsController,
          ),
          ProjectTeamView(projectDetailed: projectDetailed),
        ]),
      ),
    );
  }
}

class _ProjectContextMenu extends StatelessWidget {
  final controller;
  const _ProjectContextMenu({Key key, @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert, size: 26),
      offset: const Offset(0, 25),
      onSelected: (value) => _onSelected(value, controller),
      itemBuilder: (context) {
        return [
          // const PopupMenuItem(value: 'copyLink', child: Text('Copy link')),
          // if (controller.projectDetailed.canEdit)
          //   const PopupMenuItem(value: 'edit', child: Text('Edit')),
          if (!controller.projectDetailed.security['isInTeam'])
            PopupMenuItem(
              value: 'follow',
              child: controller.projectDetailed.isFollow
                  ? Text(tr('unFollowProjectButton'))
                  : Text(tr('followProjectButton')),
            ),
          if (controller.projectDetailed.canDelete)
            PopupMenuItem(
              textStyle: Get.theme.popupMenuTheme.textStyle
                  .copyWith(color: Get.theme.colors().colorError),
              value: 'delete',
              child: Text(
                tr('delete'),
                style: TextStyleHelper.subtitle1(
                    color: Get.theme.colors().colorError),
              ),
            )
        ];
      },
    );
  }
}

void _onSelected(value, controller) async {
  switch (value) {
    case 'copyLink':
      controller.copyLink();
      break;

    // case 'edit':
    //   await Get.find<NavigationController>().navigateToFullscreen(
    //       ProjectEditingView(),
    //       arguments: {'projectDetailed': controller.projectDetailed});
    //   break;

    case 'follow':
      controller.followProject();
      break;

    case 'delete':
      await Get.dialog(StyledAlertDialog(
        titleText: tr('deleteProject'),
        contentText: tr('deleteProjectAlert'),
        // 'Are you sure you want to delete these project?\nNote: this action cannot be undone.',
        acceptText: tr('delete').toUpperCase(),
        onCancelTap: () async => Get.back(),
        onAcceptTap: () async {
          var result = await controller.deleteProject();
          if (result != null) {
            // ignore: unawaited_futures
            Get.find<ProjectsController>(tag: 'ProjectsView').loadProjects();
            Get.back();
            Get.back();
          } else {
            print('ERROR');
          }
        },
      ));
      break;
    default:
  }
}
