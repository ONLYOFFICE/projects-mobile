import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/abstract_task_actions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/new_item_tile.dart';
import 'package:projects/presentation/views/new_task/select/select_project_view.dart';

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
        return NewItemTile(
          text: _isSelected
              ? controller.selectedProjectTitle.value
              : tr('selectProject'),
          icon: SvgIcons.project,
          textColor: controller.needToSelectProject == true
              ? Get.theme.colors().colorError
              : null,
          isSelected: _isSelected,
          caption: _isSelected ? '${tr('project')}:' : null,
          onTap: () => Get.find<NavigationController>().toScreen(
              const SelectProjectView(),
              arguments: {'controller': controller}),
        );
      },
    );
  }
}
