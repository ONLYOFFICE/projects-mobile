import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';

import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/header_widget.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';

class TasksView extends StatelessWidget {
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
        child: Icon(Icons.add_rounded),
      ),
      body: Obx(
        () {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TasksHeader(),
              if (controller.loaded.isFalse) ListLoadingSkeleton(),
              if (controller.loaded.isTrue)
                Expanded(
                  child: PaginationListView(
                    paginationController: controller.paginationController,
                    // SmartRefresher(
                    //   enablePullDown: true,
                    //   enablePullUp: false,
                    //   controller: controller.refreshController,
                    //   onRefresh: () => controller.onRefresh(),
                    child: ListView.builder(
                      itemCount: controller.paginationController.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskCell(
                            task: controller.paginationController.data[index]);
                      },
                    ),
                  ),
                ),
            ],
          );
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
        SizedBox(height: 14.5),
        Divider(height: 9, thickness: 1),
        SortTile(title: 'Deadline', sortController: sortController),
        SortTile(title: 'Priority', sortController: sortController),
        SortTile(title: 'Creation date', sortController: sortController),
        SortTile(title: 'Start date', sortController: sortController),
        SortTile(title: 'Title', sortController: sortController),
        SortTile(title: 'Order', sortController: sortController),
        SizedBox(height: 20)
      ],
    );

    var sortButton = Container(
      padding: EdgeInsets.only(right: 4),
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

    return HeaderWidget(controller: controller, sortButton: sortButton);
  }
}
