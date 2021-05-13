import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/abstract_task_actions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class ProjectTile extends StatelessWidget {
  final TaskActionsController controller;
  const ProjectTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool _isSelected = controller.selectedProjectTitle.value.isNotEmpty;
        return NewTaskInfo(
            text: _isSelected
                ? controller.selectedProjectTitle.value
                : 'Select project',
            icon: SvgIcons.project,
            textColor: controller.selectProjectError == true
                ? Theme.of(context).customColors().error
                : null,
            isSelected: _isSelected,
            caption: _isSelected ? 'Project:' : null,
            onTap: () => Get.toNamed('SelectProjectView'));
      },
    );
  }
}
