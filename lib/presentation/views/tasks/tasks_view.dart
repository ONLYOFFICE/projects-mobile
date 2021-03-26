import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/tasks_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/header_widget.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class TasksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TasksController());
    controller.getTasks();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: StyledFloatingActionButton(
        child: Icon(Icons.add_rounded),
      ),
      body: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HeaderWidget(title: 'Tasks'),
              if (controller.loaded.isFalse)
                _TasksLoading(),
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


class _TasksLoading extends StatelessWidget {
  const _TasksLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var _decoration = BoxDecoration(
      color: Theme.of(context).customColors().bgDescription,
      borderRadius: BorderRadius.circular(2)
    );

    return Container(
      child: Column(
        children: [
          LinearProgressIndicator(
            minHeight: 4,
            backgroundColor: Theme.of(context).customColors().primary,
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xffb5c4d2)),
          ),
          Shimmer.fromColors(
            baseColor: Theme.of(context).customColors().bgDescription, 
            highlightColor: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 22),
                for (var i = 0; i < 4; i++)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).customColors().bgDescription
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 12,
                              decoration: _decoration
                            ),
                            Container(
                              height: 12,
                              margin: const EdgeInsets.only(top: 6),
                              width: Get.width / 3,
                              decoration: _decoration
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: 41,
                        height: 12,
                        decoration: _decoration
                      )
                    ],
                  )
              ],
            ), 
          )
        ],
      ),
    );
  }
}