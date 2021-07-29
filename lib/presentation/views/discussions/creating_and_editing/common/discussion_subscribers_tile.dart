import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/discussions/actions/new_discussion_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/new_item_tile.dart';

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
          var toPage = controller is NewDiscussionController
              ? 'SelectDiscussionSubscribers'
              : 'ManageDiscussionSubscribersScreen';
          return Get.toNamed(toPage, arguments: {'controller': controller});
        },
      ),
    );
  }
}
