import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/discussions/actions/new_discussion_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/new_item_tile.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/discussion_editing/select/manage_discussion_subscribers_screen.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/new_discussion/select/select_dis_subscribers.dart';

class DiscussionSubscribersTile extends StatelessWidget {
  final DiscussionActionsController controller;
  const DiscussionSubscribersTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NewItemTile(
        icon: SvgIcons.subscribers,
        text: controller.subscribers.isEmpty
            ? tr('addSubscribers')
            : plural('subscribersPlural', controller.subscribers.length),
        isSelected: controller.subscribers.isNotEmpty,
        selectedIconColor: Get.theme.colors().onSurface.withOpacity(0.8),
        onTap: () {
          Get.find<NavigationController>().toScreen(
              controller is NewDiscussionController
                  ? const SelectDiscussionSubscribers()
                  : const ManageDiscussionSubscribersScreen(),
              arguments: {'controller': controller});
        },
      ),
    );
  }
}
