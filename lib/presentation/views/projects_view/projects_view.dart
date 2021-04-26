import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';
import 'package:projects/presentation/views/projects_view/projects_header_widget.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProjectsController>();
    controller.loadProjects();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: StyledFloatingActionButton(
        onPressed: () {
          controller.createNewProject();
        },
        child: AppIcon(
          icon: SvgIcons.add_project,
          width: 32,
          height: 32,
        ),
      ),
      appBar: StyledAppBar(
        bottom: ProjectHeader(),
        titleHeight: 0,
        bottomHeight: 100,
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ProjectHeader(),
            if (controller.loaded.isFalse) const ListLoadingSkeleton(),
            if (controller.loaded.isTrue)
              Expanded(
                child: PaginationListView(
                  paginationController: controller.paginationController,
                  child: ListView.builder(
                    itemBuilder: (c, i) => ProjectCell(
                        item: controller.paginationController.data[i]),
                    itemExtent: 72.0,
                    itemCount: controller.paginationController.data.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProjectHeader extends StatelessWidget {
  ProjectHeader({
    Key key,
  }) : super(key: key);

  final controller = Get.find<ProjectsController>();
  final sortController = Get.find<ProjectsSortController>();

  @override
  Widget build(BuildContext context) {
    var options = Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        SortTile(
          sortParameter: 'create_on',
          sortController: sortController,
        ),
        SortTile(
          sortParameter: 'title',
          sortController: sortController,
        ),
        const SizedBox(height: 20),
      ],
    );

    var sortButton = Container(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: () {
          Get.bottomSheet(
            SortView(sortOptions: options),
            isScrollControlled: true,
          );
        },
        child: Row(
          children: <Widget>[
            Obx(
              () => Text(
                sortController.currentSortTitle.value,
                style: TextStyleHelper.projectsSorting,
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => (sortController.currentSortOrder == 'ascending')
                  ? AppIcon(
                      icon: SvgIcons.sorting_4_ascend,
                      width: 20,
                      height: 20,
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(math.pi),
                      child: AppIcon(
                        icon: SvgIcons.sorting_4_ascend,
                        width: 20,
                        height: 20,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );

    return HeaderWidget(
      controller: controller,
      sortButton: sortButton,
    );
  }
}
