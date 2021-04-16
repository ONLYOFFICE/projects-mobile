import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/views/task_detailed/comments/task_comments_view.dart';
import 'package:projects/presentation/views/task_detailed/detailed_task_app_bar.dart';
import 'package:projects/presentation/views/task_detailed/documents/documents_view.dart';
import 'package:projects/presentation/views/task_detailed/overview/overview_screen.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtasks_view.dart';

class TaskDetailedView extends StatelessWidget {
  const TaskDetailedView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TaskItemController controller = Get.arguments['controller'];

    controller.reloadTask();

    return Obx(() {
      // if (controller.loaded.isTrue) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: DetailedTaskAppBar(
            bottom: SizedBox(
              height: 25,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TabBar(
                    isScrollable: true,
                    indicatorColor: Theme.of(context).customColors().primary,
                    labelColor: Theme.of(context).customColors().onSurface,
                    unselectedLabelColor: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.6),
                    labelStyle: TextStyleHelper.subtitle2(),
                    tabs: [
                      const Tab(text: 'Overview'),
                      _Tab(
                          title: 'Subtasks',
                          count: controller.task.value?.subtasks?.length),
                      _Tab(
                          title: 'Documents',
                          count: controller.task.value?.files?.length),
                      _Tab(
                          title: 'Comments',
                          count: controller.task.value?.comments?.length),
                    ]),
              ),
            ),
          ),
          body: TabBarView(children: [
            OverviewScreen(taskController: controller),
            SubtasksView(controller: controller),
            DocumentsView(controller: controller),
            TaskCommentsView(controller: controller)
          ]),
        ),
      );
      // } else {
      //   return const ListLoadingSkeleton();
      // }
    });
  }
}

class _Tab extends StatelessWidget {
  final String title;
  final int count;
  const _Tab({
    Key key,
    this.title,
    this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        if (count != null) const SizedBox(width: 8),
        if (count != null)
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).customColors().primary),
            child: Center(
              child: Text(count.toString(),
                  style: TextStyleHelper.subtitle2(
                      color: Theme.of(context).customColors().surface)),
            ),
          ),
      ],
    );
  }
}
