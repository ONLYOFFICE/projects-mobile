import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/abstract_task_actions_controller.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class PriorityTile extends StatelessWidget {
  final TaskActionsController controller;
  const PriorityTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => TileWithSwitch(
        title: 'High priority',
        isSelected: controller.highPriority.value,
        onChanged: controller.changePriority));
  }
}
