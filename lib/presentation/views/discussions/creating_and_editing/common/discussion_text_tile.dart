import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/new_item_tile.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_text_screen.dart';

class DiscussionTextTile extends StatelessWidget {
  final DiscussionActionsController controller;
  const DiscussionTextTile({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NewItemTile(
        text: controller.text?.value != null && controller.text.value.isNotEmpty
            ? controller.text.value
            : tr('text'),
        textColor:
            controller.setTextError == true && controller.text.value.isEmpty
                ? Get.theme.colors().colorError
                : null,
        isSelected:
            controller.text?.value != null && controller.text.value.isNotEmpty,
        icon: SvgIcons.description,
        selectedIconColor: Get.theme.colors().onSurface.withOpacity(0.8),
        onTap: () => Get.find<NavigationController>().navigateTo(
            const NewDiscussionTextScreen(),
            arguments: {'controller': controller}),
        //  Get.toNamed('NewDiscussionTextScreen',
        //     arguments: {'controller': controller}),
      ),
    );
  }
}
