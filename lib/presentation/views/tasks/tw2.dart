import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/tasks_controller.dart';
import 'package:projects/presentation/shared/widgets/header_widget.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/shared/widgets/task_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:projects/presentation/shared/custom_theme.dart';

class TasksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TasksController());

    return Scaffold(
      backgroundColor: Theme.of(context).customColors().backgroundColor,
      floatingActionButton: StyledFloatingActionButton(
        child: Icon(Icons.add_rounded),
      ),
      // appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget(title: 'Tasks'),
          Expanded(
            child: Obx(() => SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  child: ListView.builder(
                    itemBuilder: (c, i) {
                      return InkWell(
                          onTap: () async =>
                              await Get.toNamed('TaskDetailedView'),
                          child: TaskItem(item: controller.tasks[i]));
                    },
                    itemExtent: 100.0,
                    itemCount: controller.tasks.length,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
