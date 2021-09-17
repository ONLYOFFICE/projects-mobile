import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/creating_and_editing_subtask_view.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtask_cell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

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
              if (_task.subtasks.isEmpty)
                Center(
                  child: EmptyScreen(
                    icon: SvgIcons.task_not_created,
                    text: tr('noSubtasksCreated'),
                  ),
                ),
              if (_task.subtasks.isNotEmpty)
                SmartRefresher(
                  controller: controller.refreshController,
                  onRefresh: () => controller.reloadTask(showLoading: true),
                  child: ListView.builder(
                    itemCount: _task.subtasks.length,
                    padding: const EdgeInsets.only(top: 6, bottom: 50),
                    itemBuilder: (BuildContext context, int index) {
                      return SubtaskCell(
                          subtask: _task.subtasks[index], parentTask: _task);
                    },
                  ),
                ),
              if (controller?.task?.value?.canCreateSubtask == true &&
                  controller?.task?.value?.status != 2)
                _FAB(task: _task),
            ],
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}

class _FAB extends StatelessWidget {
  const _FAB({
    Key key,
    @required PortalTask task,
  })  : _task = task,
        super(key: key);

  final PortalTask _task;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 24,
      child: StyledFloatingActionButton(
        onPressed: () => Get.find<NavigationController>()
            .to(const CreatingAndEditingSubtaskView(), arguments: {
          'taskId': _task.id,
          'projectId': _task.projectOwner.id,
          'forEditing': false,
        }),
        child: AppIcon(
          icon: SvgIcons.add_fab,
          color: Get.theme.colors().onPrimarySurface,
        ),
      ),
    );
  }
}
