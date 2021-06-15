import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_search_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';

class SelectProjectView extends StatelessWidget {
  const SelectProjectView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _projectsController = Get.put(
        ProjectsController(
          Get.find<ProjectsFilterController>(),
          Get.put(PaginationController(), tag: 'SelectProjectView'),
        ),
        tag: 'SelectProjectView');

    _projectsController.loadProjects();

    var _searchController = Get.put(ProjectSearchController());

    return Scaffold(
      appBar: StyledAppBar(
        titleText: 'Select project',
        bottomHeight: 44,
        bottom: SearchField(
          hintText: 'Search for projects...',
          controller: _searchController.searchInputController,
          showClearIcon: true,
          onSubmitted: (value) => _searchController.newSearch(value),
          onClearPressed: () => _searchController.clearSearch(),
        ),
      ),
      body: Obx(() {
        if (_searchController.switchToSearchView.isTrue &&
            _searchController.searchResult.isNotEmpty) {
          return ProjectsList(projects: _searchController.searchResult);
        }
        if (_searchController.switchToSearchView.isTrue &&
            _searchController.searchResult.isEmpty &&
            _searchController.loaded.isTrue) {
          return const NothingFound();
        }
        if (_projectsController.loaded.isTrue &&
            _searchController.switchToSearchView.isFalse) {
          return ProjectsList(
              projects: _projectsController.paginationController.data);
        }
        return const ListLoadingSkeleton();
      }),
    );
  }
}

class ProjectsList extends StatelessWidget {
  final List projects;
  const ProjectsList({
    Key key,
    @required this.projects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewTaskController>();
    return ListView.separated(
      itemCount: projects.length,
      separatorBuilder: (BuildContext context, int index) {
        return const StyledDivider(leftPadding: 16, rightPadding: 16);
      },
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: InkResponse(
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
                                    color: Theme.of(context)
                                        .customColors()
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
