import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/widgets/header_widget.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';

class TasksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var taskStatusesController = Get.find<TaskStatusesController>();
    taskStatusesController.getStatuses();
    var controller = Get.put(TasksController());
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
              HeaderWidget(controller: controller),
              if (controller.loaded.isFalse) ListLoadingSkeleton(),
              if (controller.loaded.isTrue)
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    controller: controller.refreshController,
                    onRefresh: () => controller.onRefresh(),
                    child: ListView.builder(
                      itemCount: controller.tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskCell(task: controller.tasks[index]);
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
