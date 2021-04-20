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
      () => NewTaskInfo(
          icon: SvgIcons.due_date,
          text: controller.dueDateText.value,
          onTap: () => Get.toNamed('SelectDateView',
              arguments: {'controller': controller, 'startDate': false})),
    );
  }
}
