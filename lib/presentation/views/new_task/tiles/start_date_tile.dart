import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_actions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class StartDateTile extends StatelessWidget {
  final TaskActionsController controller;
  const StartDateTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool _isSelected = controller.startDateText.value.isNotEmpty;
        return NewTaskInfo(
            icon: SvgIcons.start_date,
            text:
                _isSelected ? controller.startDateText.value : 'Set start date',
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
                    onPressed: () => controller.changeStartDate(null))
                : null,
            suffixPadding: const EdgeInsets.only(right: 10),
            onTap: () => Get.toNamed('SelectDateView',
                arguments: {'controller': controller, 'startDate': true}));
      },
    );
  }
}
