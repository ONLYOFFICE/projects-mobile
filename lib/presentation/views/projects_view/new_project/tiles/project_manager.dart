import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/widgets/new_item_tile.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class ProjectManagerTile extends StatelessWidget {
  const ProjectManagerTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool _isNotEmpty = controller.isPMSelected.value;

        return NewItemTile(
          caption: _isNotEmpty ? '${tr('project')}:' : null,
          text: _isNotEmpty ? controller.managerName.value : tr('choosePM'),
          icon: SvgIcons.user,
          textColor: controller.needToFillManager.value
              ? Get.theme.colors().colorError
              : null,
          iconColor: Get.theme.colors().onBackground.withOpacity(0.4),
          selectedIconColor: Get.theme.colors().onBackground,
          isSelected: _isNotEmpty,
          suffix: _isNotEmpty
              ? InkWell(
                  onTap: controller.removeManager,
                  child: Icon(
                    Icons.close,
                    size: 24,
                    color: Get.theme.colors().onBackground,
                  ),
                )
              : null,
          onTap: () => Get.find<NavigationController>().toScreen(
              const ProjectManagerSelectionView(),
              arguments: {'controller': controller}),
        );
      },
    );
  }
}
