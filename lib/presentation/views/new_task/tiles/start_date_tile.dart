import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class StartDateTile extends StatelessWidget {
  final controller;
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
            onTap: () => Get.toNamed('SelectDateView',
                arguments: {'controller': controller, 'startDate': true}));
      },
    );
  }
}
