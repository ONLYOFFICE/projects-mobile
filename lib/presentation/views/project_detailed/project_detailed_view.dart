import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
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

  @override
  void initState() {
    super.initState();
    discussionsController =
        Get.put(ProjectDiscussionsController(projectDetailed.id));

    projectController =
        Get.put(ProjectDetailsController(Get.arguments['projectDetailed']));

    projectController.setup();

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
            // IconButton(
            //     icon: const Icon(Icons.edit_outlined),
            //     onPressed: () => Get.toNamed('ProjectEditingView',
            //         arguments: {'projectDetailed': projectDetailed})),
            _ProjectContextMenu(controller: projectController)
          ],
          bottom: SizedBox(
            height: 40,
            child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor: Theme.of(context).customColors().primary,
                labelColor: Theme.of(context).customColors().onSurface,
                unselectedLabelColor:
                    Theme.of(context).customColors().onSurface.withOpacity(0.6),
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
          // const PopupMenuItem(
          //     value: 'follow', child: Text('Follow / Unfollow project')),
          if (controller.projectDetailed.canDelete)
            PopupMenuItem(
              textStyle: Theme.of(context)
                  .popupMenuTheme
                  .textStyle
                  .copyWith(color: Theme.of(context).customColors().error),
              value: 'delete',
              child: Text(tr('delete')),
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

    case 'edit':
      await Get.toNamed('ProjectEditingView',
          arguments: {'projectDetailed': controller.projectDetailed});
      break;

    case 'follow':
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
