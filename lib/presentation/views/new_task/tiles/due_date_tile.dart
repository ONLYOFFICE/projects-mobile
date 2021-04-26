import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class DueDateTile extends StatelessWidget {
  final controller;
  const DueDateTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool _isSelected = controller.dueDateText.value.isNotEmpty;
        return NewTaskInfo(
            icon: SvgIcons.due_date,
            text: _isSelected ? controller.dueDateText.value : 'Set due date',
            caption: _isSelected ? 'Start date:' : null,
            isSelected: _isSelected,
            onTap: () => Get.toNamed('SelectDateView',
                arguments: {'controller': controller, 'startDate': false}));
      },
    );
  }
}
