import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class AppBarMenuButton extends StatelessWidget {
  final DiscussionItemController controller;
  const AppBarMenuButton({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert, size: 26),
      offset: const Offset(0, 25),
      // onSelected: (value) => _onSelected(value, controller),
      onSelected: (value) => _onSelected(context, controller, value),
      itemBuilder: (context) {
        return [
          if (controller.discussion.value.canEdit)
            PopupMenuItem(value: 'Edit', child: Text(tr('Edit discussion'))),
          // TODO realize
          // const PopupMenuItem(
          //     value: 'Create task', child: Text('Create task on discussion')),
          PopupMenuItem(
            value: 'Subscribe',
            child: Text(
              controller.isSubscribed
                  ? tr('unsubscribeFromComments')
                  : tr('subscribeToComments'),
            ),
          ),
          if (controller.discussion.value.canEdit)
            PopupMenuItem(
              value: 'Delete',
              textStyle: Get.theme.popupMenuTheme.textStyle
                  .copyWith(color: Get.theme.colors().colorError),
              child: Text(
                tr('deleteDiscussion'),
              ),
            ),
        ];
      },
    );
  }
}

void _onSelected(
    context, DiscussionItemController controller, String value) async {
  switch (value) {
    case 'Edit':
      await controller.toDiscussionEditingScreen();
      break;
    case 'Subscribe':
      await controller.subscribeToMessageAction();
      break;
    case 'Delete':
      await controller.deleteMessage(context);
      break;
    default:
  }
}
