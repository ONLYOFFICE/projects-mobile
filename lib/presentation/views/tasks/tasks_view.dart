import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/presentation/views/tasks/tasks_header_widget.dart';

class TasksView extends StatelessWidget {
  const TasksView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var taskStatusesController = Get.find<TaskStatusesController>();
    taskStatusesController.getStatuses();
    var controller = Get.find<TasksController>();
    controller.getTasks();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: StyledFloatingActionButton(
        onPressed: () => Get.toNamed('NewTaskView'),
        child: const Icon(Icons.add_rounded),
      ),
      appBar: StyledAppBar(
        bottom: TasksHeader(),
        titleHeight: 0,
        bottomHeight: 100,
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
        SortTile(title: 'Deadline', sortController: sortController),
        SortTile(title: 'Priority', sortController: sortController),
        SortTile(title: 'Creation date', sortController: sortController),
        SortTile(title: 'Start date', sortController: sortController),
        SortTile(title: 'Title', sortController: sortController),
        SortTile(title: 'Order', sortController: sortController),
        const SizedBox(height: 20)
      ],
    );

    var sortButton = Container(
      padding: const EdgeInsets.only(right: 4),
      child: GestureDetector(
        onTap: () {
          Get.bottomSheet(SortView(sortOptions: options),
              isScrollControlled: true);
        },
        child: Row(
          children: <Widget>[
            Text(
              sortController.currentSortText.value,
              style: TextStyleHelper.projectsSorting,
            ),
            const SizedBox(width: 8),
            SVG.createSized(
                'lib/assets/images/icons/sorting_3_descend.svg', 20, 20),
          ],
        ),
      ),
    );

    return TasksHeaderWidget(controller: controller, sortButton: sortButton);
  }
}
