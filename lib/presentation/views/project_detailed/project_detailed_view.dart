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
import 'package:projects/domain/controllers/projects/detailed_project/project_discussions_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_tab.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
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

class _ProjectDetailedViewState extends State<ProjectDetailedView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  // ignore: prefer_final_fields
  RxInt _activeIndex = 0.obs;

  ProjectDetailed? projectDetailed = Get.arguments['projectDetailed'];

  ProjectDetailsController? projectController;
  ProjectDiscussionsController? discussionsController;
  final documentsController = Get.find<DocumentsController>();

  @override
  void initState() {
    super.initState();

    discussionsController =
        Get.put(ProjectDiscussionsController(projectDetailed!));

    projectController = Get.find<ProjectDetailsController>();
    projectController!.setup(Get.arguments['projectDetailed']);

    documentsController.setupFolder(
        folderName: projectDetailed!.title!,
        folderId: projectDetailed!.projectFolder);

    _tabController = TabController(
      vsync: this,
      length: 6,
    );

    projectController!.addProjectDetailsListeners(() {
      projectDetailed = projectController!.projectData;
      discussionsController!.setup(projectDetailed!);
      documentsController.setupFolder(
          folderName: projectDetailed!.title!,
          folderId: projectDetailed!.projectFolder);
    });

    documentsController.filesCount.listen((count) {
      projectController!.docsCount.value = count;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController!.addListener(() {
      if (_activeIndex.value == _tabController!.index) return;

      _activeIndex.value = _tabController!.index;
    });

    return Obx(
      () => Scaffold(
        appBar: StyledAppBar(
          actions: [
            projectController!.projectData!.canEdit!
                ? IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => Get.find<NavigationController>().to(
                            EditProjectView(
                                projectDetailed: projectController!.projectData),
                            arguments: {
                              'projectDetailed': projectController!.projectData
                            }))
                : const SizedBox(),
            if (!projectController!.projectData!.security!['isInTeam'] ||
                projectController!.projectData!.canDelete!)
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
                      count: projectController!.tasksCount.value),
                  CustomTab(
                      title: tr('milestones'),
                      currentTab: _activeIndex.value == 2,
                      count: projectController!.milestoneCount.value),
                  CustomTab(
                      title: tr('discussions'),
                      currentTab: _activeIndex.value == 3,
                      count: projectController!.projectData!.discussionCount),
                  CustomTab(
                      title: tr('documents'),
                      currentTab: _activeIndex.value == 4,
                      count: projectController!.docsCount.value),
                  CustomTab(
                      title: tr('team'),
                      currentTab: _activeIndex.value == 5,
                      count: projectController!.projectData!.participantCount),
                ]),
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          ProjectOverview(
              projectController: projectController,
              tabController: _tabController),
          ProjectTaskScreen(projectDetailed: projectController!.projectData),
          ProjectMilestonesScreen(
              projectDetailed: projectController!.projectData),
          ProjectDiscussionsScreen(controller: discussionsController),
          EntityDocumentsView(
            folderId: projectController!.projectData!.projectFolder,
            folderName: projectController!.projectData!.title,
            documentsController: documentsController,
          ),
          ProjectTeamView(
              projectDetailed: projectController!.projectData,
              fabAction: projectController!.manageTeamMembers),
        ]),
      ),
    );
  }
}

class _ProjectContextMenu extends StatelessWidget {
  final controller;
  const _ProjectContextMenu({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert, size: 26),
      offset: const Offset(0, 25),
      onSelected: (dynamic value) => _onSelected(value, controller, context),
      itemBuilder: (context) {
        return [
          // const PopupMenuItem(value: 'copyLink', child: Text('Copy link')),
          // if (controller.projectDetailed.canEdit)
          //   const PopupMenuItem(value: 'edit', child: Text('Edit')),
          if (!controller.projectData.security['isInTeam'])
            PopupMenuItem(
              value: 'follow',
              child: controller.projectData.isFollow
                  ? Text(tr('unFollowProjectButton'))
                  : Text(tr('followProjectButton')),
            ),
          if (controller.projectData.canDelete)
            PopupMenuItem(
              textStyle: Get.theme.popupMenuTheme.textStyle!
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

void _onSelected(value, controller, context) async {
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
            Get.back();
            Get.back();
            MessagesHandler.showSnackBar(
              context: context,
              text: tr('projectDeleted'),
            );
            locator<EventHub>().fire('needToRefreshProjects');
          } else {
            print('ERROR');
          }
        },
      ));
      break;
    default:
  }
}
