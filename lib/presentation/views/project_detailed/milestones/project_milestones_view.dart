import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_data_source.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_filter_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_sort_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_tasks_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/views/project_detailed/milestones/milestone_cell.dart';

class ProjectMilestonesScreen extends StatelessWidget {
  final ProjectDetailed projectDetailed;
  const ProjectMilestonesScreen({
    Key key,
    @required this.projectDetailed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<MilestonesDataSource>();
    controller.setup(projectDetailed.id);

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Header(),
          if (controller.loaded.isFalse) const ListLoadingSkeleton(),
          if (controller.loaded.isTrue &&
              controller.paginationController.data.isEmpty &&
              !controller.filterController.hasFilters.value)
            Expanded(
              child: Center(
                child: EmptyScreen(
                    icon: AppIcon(icon: SvgIcons.milestone_not_created),
                    text: 'There are no milestones has been created yet'),
              ),
            ),
          if (controller.loaded.isTrue &&
              controller.paginationController.data.isEmpty &&
              controller.filterController.hasFilters.value)
            Expanded(
              child: Center(
                child: EmptyScreen(
                    icon: AppIcon(icon: SvgIcons.not_found),
                    text: 'There are no milestones matching these filters'),
              ),
            ),
          if (controller.loaded.isTrue &&
              controller.paginationController.data.isNotEmpty)
            Expanded(
              child: PaginationListView(
                paginationController: controller.paginationController,
                child: ListView.builder(
                  itemBuilder: (c, i) => MilestoneCell(
                      milestone: controller.paginationController.data[i]),
                  itemExtent: 72.0,
                  itemCount: controller.paginationController.data.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  Header({
    Key key,
  }) : super(key: key);
  final controller = Get.find<MilestonesDataSource>();
  // final controller = Get.find<ProjectTasksController>();
  // final sortController = Get.find<MilestonesSortController>();
  // final filterController = Get.find<MilestonesFilterController>();

  @override
  Widget build(BuildContext context) {
    var options = Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        SortTile(
            sortParameter: 'deadline',
            sortController: controller.sortController),
        SortTile(
            sortParameter: 'create_on',
            sortController: controller.sortController),
        SortTile(
            sortParameter: 'title', sortController: controller.sortController),
        const SizedBox(height: 20)
      ],
    );

    var sortButton = Container(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: () {
          Get.bottomSheet(SortView(sortOptions: options),
              isScrollControlled: true);
        },
        child: Row(
          children: <Widget>[
            Obx(
              () => Text(
                controller.sortController.currentSortTitle.value,
                style: TextStyleHelper.projectsSorting,
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => (controller.sortController.currentSortOrder == 'ascending')
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

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              sortButton,
              Container(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () async => Get.toNamed('MilestoneFilterScreen'),
                      child: FiltersButton(controler: controller),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
