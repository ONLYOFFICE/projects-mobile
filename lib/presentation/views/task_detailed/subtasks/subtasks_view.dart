import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtask_cell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SubtasksView extends StatelessWidget {
  final TaskItemController controller;
  const SubtasksView({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _task = controller.task.value;
    return Obx(
      () {
        if (controller.loaded.isTrue) {
          return Stack(
            children: [
              SmartRefresher(
                controller: controller.refreshController,
                onRefresh: controller.reloadTask,
                child: ListView.separated(
                  itemCount: _task.subtasks.length,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  separatorBuilder: (_, int index) {
                    return const Divider(indent: 56, thickness: 1);
                  },
                  itemBuilder: (_, int index) {
                    return SubtaskCell(subtask: _task.subtasks[index]);
                  },
                ),
              ),
              if (controller?.task?.value?.canCreateSubtask)
                Positioned(
                    right: 16,
                    bottom: 24,
                    child: StyledFloatingActionButton(
                      onPressed: () => Get.toNamed('NewSubtaskView',
                          arguments: {'taskId': _task.id}),
                      child: const Icon(Icons.add_rounded, size: 34),
                    )),
            ],
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}
