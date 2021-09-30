import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/new_milestone_controller.dart';
import 'package:projects/domain/controllers/projects/project_search_controller.dart';
import 'package:projects/domain/controllers/projects/projects_with_presets.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';

class SelectProjectView extends StatelessWidget {
  const SelectProjectView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.arguments['controller'];
    var projectsController = ProjectsWithPresets.myProjectsController;

    var userController = Get.find<UserController>();

    if (userController.user.isAdmin ||
        userController.user.isOwner ||
        userController.user.listAdminModules.contains('projects') ||
        ((controller is NewTaskController) &&
            userController.securityInfo.canCreateTask) ||
        ((controller is DiscussionActionsController) &&
            userController.securityInfo.canCreateMessage) ||
        ((controller is NewMilestoneController) &&
            userController.securityInfo.canCreateMilestone)) {
      projectsController = ProjectsWithPresets.activeProjectsController;
    }

    var searchController =
        Get.put(ProjectSearchController(onlyMyProjects: true));

    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor:
          platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        titleText: tr('selectProject'),
        backButtonIcon: Get.put(PlatformController()).isMobile
            ? const Icon(Icons.arrow_back_rounded)
            : const Icon(Icons.close),
        bottomHeight: 44,
        bottom: SearchField(
          hintText: tr('searchProjects'),
          controller: searchController.searchInputController,
          showClearIcon: true,
          onSubmitted: (value) => searchController.newSearch(value),
          onClearPressed: () => searchController.clearSearch(),
        ),
      ),
      body: Obx(() {
        if (searchController.switchToSearchView.value == true &&
            searchController.searchResult.isNotEmpty) {
          return ProjectList(
            controller: controller,
            projects: searchController.searchResult,
          );
        }
        if (searchController.switchToSearchView.value == true &&
            searchController.searchResult.isEmpty &&
            searchController.loaded.value == true) {
          return Column(children: [const NothingFound()]);
        }
        if (projectsController.loaded.value == true &&
            searchController.switchToSearchView.value == false) {
          return ProjectList(
            projects: projectsController.paginationController.data,
            controller: controller,
          );
        }
        return const ListLoadingSkeleton();
      }),
    );
  }
}

class ProjectList extends StatelessWidget {
  final List projects;
  final controller;
  const ProjectList({
    Key key,
    @required this.projects,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: projects.length,
      separatorBuilder: (BuildContext context, int index) {
        return const StyledDivider(leftPadding: 16, rightPadding: 16);
      },
      itemBuilder: (BuildContext context, int index) {
        return Material(
          color: Get.find<PlatformController>().isMobile
              ? Get.theme.colors().backgroundColor
              : Get.theme.colors().surface,
          child: InkWell(
            onTap: () {
              controller.changeProjectSelection(
                  id: projects[index].id, title: projects[index].title);
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
                          projects[index].title,
                          style: TextStyleHelper.projectTitle,
                        ),
                        Text(projects[index].responsible.displayName,
                            style: TextStyleHelper.caption(
                                    color: Get.theme
                                        .colors()
                                        .onSurface
                                        .withOpacity(0.6))
                                .copyWith(height: 1.667)),
                      ],
                    ),
                  ),
                  // Icon(Icons.check_rounded)
                ],
              ),
            ),
          ),
        );
      },
    );
    // },
    // );
  }
}
