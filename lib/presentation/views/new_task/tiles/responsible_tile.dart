import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/new_item_tile.dart';
import 'package:projects/presentation/shared/project_team_responsible.dart';

class ResponsibleTile extends StatelessWidget {
  final controller;
  final bool enableUnderline;
  final Widget suffixIcon;
  const ResponsibleTile({
    Key key,
    @required this.controller,
    this.enableUnderline = true,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // ignore: omit_local_variable_types
        bool _isSelected = controller.responsibles.isNotEmpty;
        return NewItemTile(
          isSelected: _isSelected,
          caption: _isSelected ? '${tr('assignedTo')}:' : null,
          enableBorder: enableUnderline,
          iconColor: Get.theme.colors().onBackground.withOpacity(0.4),
          selectedIconColor: Get.theme.colors().onBackground,
          text: _isSelected
              ? controller.responsibles.length == 1
                  ? controller.responsibles[0]?.displayName
                  : plural('responsibles', controller.responsibles.length)
              : tr('addResponsible'),
          suffix: _isSelected
              ? suffixIcon ??
                  Icon(Icons.navigate_next,
                      size: 24, color: Get.theme.colors().onBackground)
              : null,
          suffixPadding: const EdgeInsets.only(right: 21),
          icon: SvgIcons.person,
          onTap: () => Get.find<NavigationController>().toScreen(
              const ProjectTeamResponsibleSelectionView(),
              arguments: {'controller': controller}),
        );
      },
    );
  }
}
