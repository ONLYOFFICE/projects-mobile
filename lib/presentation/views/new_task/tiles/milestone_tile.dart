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
      () {
        bool _isSelected = controller.slectedMilestoneTitle.value.isNotEmpty;
        return NewTaskInfo(
            text: _isSelected ? controller.slectedMilestoneTitle.value : 'None',
            icon: SvgIcons.milestone,
            // because color is always black
            isSelected: true,
            caption: 'Milestone:',
            onTap: () => Get.toNamed('SelectMilestoneView'));
      },
    );
  }
}
