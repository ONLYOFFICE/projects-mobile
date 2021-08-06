import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/creating_and_editing_subtask_view.dart';
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
        if (controller.loaded.value == true) {
          return Stack(
            children: [
              SmartRefresher(
                controller: controller.refreshController,
                onRefresh: () => controller.reloadTask(showLoading: true),
                child: ListView.builder(
                  itemCount: _task.subtasks.length,
                  padding: const EdgeInsets.only(top: 6, bottom: 50),
                  itemBuilder: (BuildContext context, int index) {
                    return SubtaskCell(subtask: _task.subtasks[index]);
                  },
                ),
              ),
              if (controller?.task?.value?.canCreateSubtask)
                Positioned(
                  right: 16,
                  bottom: 24,
                  child: StyledFloatingActionButton(
                    onPressed: () => Get.find<NavigationController>()
                        .to(const CreatingAndEditingSubtaskView(), arguments: {
                      'taskId': _task.id,
                      'forEditing': false,
                    }),
                    child: AppIcon(icon: SvgIcons.add_fab),
                  ),
                ),
            ],
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}
