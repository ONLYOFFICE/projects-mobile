import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/widgets/new_item_tile.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_members_view.dart';

class TeamMembersTile extends StatelessWidget {
  const TeamMembersTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool _isNotEmpty = controller.selectedTeamMembers.isNotEmpty;

        return NewItemTile(
          caption: _isNotEmpty ? '${tr('team')}:' : null,
          text:
              _isNotEmpty ? controller.teamMembersTitle : tr('addTeamMembers'),
          icon: SvgIcons.users,
          iconColor: Get.theme.colors().onBackground.withOpacity(0.4),
          selectedIconColor: Get.theme.colors().onBackground,
          isSelected: _isNotEmpty,
          suffix: _isNotEmpty
              ? InkWell(
                  onTap: controller.editTeamMember,
                  child: Icon(
                    controller.selectedTeamMembers.length >= 2
                        ? Icons.navigate_next
                        : Icons.close,
                    size: 24,
                    color: Get.theme.colors().onBackground,
                  ),
                )
              : null,
          onTap: () => Get.find<NavigationController>().toScreen(
              const TeamMembersSelectionView(),
              arguments: {'controller': controller}),
        );
      },
    );
  }
}
