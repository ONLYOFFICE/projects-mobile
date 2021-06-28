import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class NotifyResponsiblesTile extends StatelessWidget {
  final NewTaskController controller;
  const NotifyResponsiblesTile({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => TileWithSwitch(
        title: tr('notifyResponsible'),
        isSelected: controller.notifyResponsibles.value,
        onChanged: controller.changeNotifyResponsiblesValue,
        enableBorder: true));
  }
}
