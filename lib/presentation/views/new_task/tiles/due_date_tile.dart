import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
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
            suffix: _isSelected
                ? IconButton(
                    icon: Icon(Icons.close_rounded,
                        size: 23,
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6)),
                    onPressed: () => controller.changeDueDate(null))
                : null,
            suffixPadding: const EdgeInsets.only(right: 10),
            onTap: () => Get.toNamed('SelectDateView',
                arguments: {'controller': controller, 'startDate': false}));
      },
    );
  }
}
