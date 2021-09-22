import 'package:flutter/material.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_controller.dart';

class SubtaskCheckBox extends StatelessWidget {
  const SubtaskCheckBox({
    Key key,
    @required this.subtaskController,
  }) : super(key: key);

  final SubtaskController subtaskController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: IgnorePointer(
        ignoring: !subtaskController.canEdit,
        child: Checkbox(
          value: subtaskController.subtask.value.status == 2,
          activeColor: const Color(0xFF666666),
          onChanged: (value) {
            subtaskController.updateSubtaskStatus(
              context: context,
              taskId: subtaskController.subtask.value.taskId,
              subtaskId: subtaskController.subtask.value.id,
            );
          },
        ),
      ),
    );
  }
}
