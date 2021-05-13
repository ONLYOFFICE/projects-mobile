import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/projects/detailed_project/detailed_project_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/project_detailed/project_discussions_view.dart';
import 'package:projects/presentation/views/project_detailed/documents/project_documents_view.dart';
import 'package:projects/presentation/views/project_detailed/milestones/project_milestones_view.dart';
import 'package:projects/presentation/views/project_detailed/project_overview.dart';
import 'package:projects/presentation/views/project_detailed/project_task_screen.dart';
import 'package:projects/presentation/views/project_detailed/project_team_view.dart';
import 'package:projects/presentation/views/task_detailed/task_detailed_view.dart';

class ProjectDetailedView extends StatefulWidget {
  ProjectDetailedView({Key key}) : super(key: key);

  @override
  _ProjectDetailedViewState createState() => _ProjectDetailedViewState();
}

class _ProjectDetailedViewState extends State<ProjectDetailedView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeIndex = 0;

  ProjectDetailed projectDetailed = Get.arguments['projectDetailed'];

  var projectController =
      Get.put(ProjectDetailsController(Get.arguments['projectDetailed']));

  @override
  void initState() {
    super.initState();
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
      if (_tabController.indexIsChanging) {
        setState(() {
          _activeIndex = _tabController.index;
        });
      }
    });
    return Scaffold(
      floatingActionButton: Visibility(
        visible: _activeIndex == 2 || _activeIndex == 1,
        child: StyledFloatingActionButton(
          onPressed: () {
            if (_activeIndex == 2) projectController.createNewMilestone();
            if (_activeIndex == 1) projectController.createTask();
          },
          child: _activeIndex == 2
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
          //   icon: const Icon(Icons.edit_outlined),
          //   onPressed: () => print('da'),
          // ),
        ],
        bottom: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
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
                  const Tab(text: 'Overview'),
                  CustomTab(
                      title: 'Tasks',
                      currentTab: _activeIndex == 1,
                      count: projectController.projectDetailed.taskCount),
                  CustomTab(
                      title: 'Milestones',
                      currentTab: _activeIndex == 2,
                      count: projectController.projectDetailed.milestoneCount),
                  CustomTab(
                      title: 'Discussions',
                      currentTab: _activeIndex == 3,
                      count: projectController.projectDetailed.discussionCount),
                  Obx(
                    () => CustomTab(
                        title: 'Documents',
                        currentTab: _activeIndex == 4,
                        count: projectController.docsCount.value),
                  ),
                  CustomTab(
                      title: 'Team',
                      currentTab: _activeIndex == 5,
                      count:
                          projectController.projectDetailed.participantCount),
                ]),
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        ProjectOverview(
            projectDetailed: projectDetailed, tabController: _tabController),
        ProjectTaskScreen(projectDetailed: projectDetailed),
        ProjectMilestonesScreen(projectDetailed: projectDetailed),
        ProjectDiscussionsScreen(projectDetailed: projectDetailed),
        ProjectDocumentsView(projectDetailed: projectDetailed),
        ProjectTeamView(projectDetailed: projectDetailed),
      ]),
    );
  }
}

// StyledFloatingActionButton getWidget(_activeIndex, projectController) {
//   if (_activeIndex == 2)
//     return StyledFloatingActionButton(
//       onPressed: () {
//         projectController.createNewMilestone();
//       },
//       child: AppIcon(
//         icon: SvgIcons.add_milestone,
//         width: 32,
//         height: 32,
//       ),
//     );
//   // if (_activeIndex == 1)
//   return StyledFloatingActionButton(
//     onPressed: () {
//       projectController.createTask();
//     },
//     child: AppIcon(
//       icon: SvgIcons.add_button,
//       width: 32,
//       height: 32,
//     ),
//   );
// }
