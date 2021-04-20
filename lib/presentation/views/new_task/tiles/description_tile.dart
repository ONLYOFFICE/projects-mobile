import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class DescriptionTile extends StatelessWidget {
  final controller;
  const DescriptionTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NewTaskInfo(
          text: controller.descriptionText.value,
          onTap: () => Get.toNamed('NewTaskDescription')),
    );
  }
}
