import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class MilestoneTile extends StatelessWidget {
  final controller;
  const MilestoneTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NewTaskInfo(
          text: controller.milestoneTileText.value,
          icon: SvgIcons.milestone,
          onTap: () => Get.toNamed('SelectMilestoneView')),
    );
  }
}
