import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';
import 'package:projects/presentation/views/tasks/tasks_header_widget.dart';

class TasksView extends StatelessWidget {
  const TasksView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TasksController>();
    controller.loadTasks();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: Obx(() => AnimatedPadding(
          padding:
              EdgeInsets.only(bottom: controller.fabIsRaised.isTrue ? 48 : 0),
          duration: const Duration(milliseconds: 100),
          child: StyledFloatingActionButton(
              onPressed: () => Get.toNamed('NewTaskView'),
              child: const Icon(Icons.add_rounded)))),
      appBar: StyledAppBar(
        bottom: TasksHeader(),
        titleHeight: 0,
        bottomHeight: 100,
        showBackButton: false,
      ),
      body: Obx(
        () {
          if (controller.loaded.isFalse)
            return const ListLoadingSkeleton();
          else {
            return PaginationListView(
              paginationController: controller.paginationController,
              child: ListView.builder(
                itemCount: controller.paginationController.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return TaskCell(
                      task: controller.paginationController.data[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class TasksHeader extends StatelessWidget {
  TasksHeader({
    Key key,
  }) : super(key: key);

  final controller = Get.find<TasksController>();
  final sortController = Get.find<TasksSortController>();

  @override
  Widget build(BuildContext context) {
    var options = Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        SortTile(sortParameter: 'deadline', sortController: sortController),
        SortTile(sortParameter: 'priority', sortController: sortController),
        SortTile(sortParameter: 'create_on', sortController: sortController),
        SortTile(sortParameter: 'start_date', sortController: sortController),
        SortTile(sortParameter: 'title', sortController: sortController),
        SortTile(sortParameter: 'sort_order', sortController: sortController),
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

    return TasksHeaderWidget(controller: controller, sortButton: sortButton);
  }
}
