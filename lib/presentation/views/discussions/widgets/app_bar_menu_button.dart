import 'package:flutter/material.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';

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
      onSelected: (value) => _onSelected(controller, value),
      itemBuilder: (context) {
        return [
          if (controller.discussion.value.canEdit)
            const PopupMenuItem(value: 'Edit', child: Text('Edit discussion')),
          const PopupMenuItem(
              value: 'Create task', child: Text('Create task on discussion')),
          PopupMenuItem(
              value: 'Subscribe',
              child: Text(controller.isSubscribed
                  ? 'Unsubscribe from comments'
                  : 'Subscribe to comments')),
          if (controller.discussion.value.canEdit)
            const PopupMenuItem(
                value: 'Delete', child: Text('Delete discussion')),
        ];
      },
    );
  }
}

void _onSelected(DiscussionItemController controller, String value) async {
  var actions = {
    'Subscribe': controller.subscribeToMessageAction,
    'Delete': controller.deleteMessage,
  };
  await actions[value]();
}
