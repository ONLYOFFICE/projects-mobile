import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/views/task_detailed/detailed_task_app_bar.dart';
import 'package:projects/presentation/views/task_detailed/overview/overview_screen.dart';

class TaskDetailedView extends StatelessWidget {
  const TaskDetailedView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TaskItemController controller = Get.arguments['controller'];

    print(controller.task.value.title);

    return Obx(() {
      return DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: DetailedTaskAppBar(
            bottom: SizedBox(
              height: 25,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TabBar(
                    isScrollable: true,
                    indicatorColor: Theme.of(context).customColors().onPrimary,
                    labelColor: Theme.of(context).customColors().onPrimary,
                    unselectedLabelColor: Theme.of(context)
                        .customColors()
                        .onPrimary
                        .withOpacity(0.6),
                    labelStyle: TextStyleHelper.subtitle2,
                    tabs: [
                      Tab(text: 'Overview'),
                      Tab(
                          text: 'Subtasks' +
                              controller.task.value.subtasks.length.toString()),
                      Tab(text: 'Documents'),
                      Tab(text: 'Related Tasks'),
                      Tab(text: 'Comments'),
                      Tab(text: 'Gantt Chart'),
                    ]),
              ),
            ),
          ),
          body: TabBarView(children: [
            for (var i = 0; i < 6; i++)
              OverviewScreen(taskController: controller)
          ]),
        ),
      );
    });
  }
}
