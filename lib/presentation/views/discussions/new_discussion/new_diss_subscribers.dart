import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/abstract_discussion_actions_controller.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class NewDiscussionSubscribers extends StatelessWidget {
  final DiscussionActionsController controller;
  const NewDiscussionSubscribers({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NewTaskInfo(
        icon: SvgIcons.subscribers,
        text: controller.subscribers.isEmpty
            ? tr('addSubscribers')
            : plural('subscribersPlural', controller.subscribers.length),
        // : '${controller.subscribers.length} subscribers',
        onTap: () => Get.toNamed('SelectDiscussionSubscribers',
            arguments: {'controller': controller}),
      ),
    );
  }
}
