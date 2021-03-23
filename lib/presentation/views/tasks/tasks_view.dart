import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/tasks_controller.dart';
import 'package:projects/presentation/shared/app_colors.dart';
import 'package:projects/presentation/shared/widgets/header_widget.dart';
import 'package:projects/presentation/shared/widgets/project_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TasksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TasksController controller = Get.put(TasksController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                  itemBuilder: (c, i) =>
                      ProjectItem(item: controller.tasks[i]),
                  itemExtent: 100.0,
                  itemCount: controller.tasks.length,
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}
