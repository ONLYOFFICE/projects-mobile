import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_actions_controller.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class MilestoneTile extends StatelessWidget {
  final TaskActionsController controller;
  const MilestoneTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // ignore: omit_local_variable_types
        bool _isSelected = controller.selectedMilestoneTitle.value.isNotEmpty;
        return NewTaskInfo(
            text:
                _isSelected ? controller.selectedMilestoneTitle.value : 'None',
            icon: SvgIcons.milestone,
            // because color is always black
            isSelected: true,
            caption: 'Milestone:',
            onTap: () => Get.toNamed('SelectMilestoneView',
                arguments: {'controller': controller}));
      },
    );
  }
}
