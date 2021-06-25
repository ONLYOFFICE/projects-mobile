import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/abstract_discussion_actions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class NewDiscussionText extends StatelessWidget {
  final DiscussionActionsController controller;
  const NewDiscussionText({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NewTaskInfo(
        text: controller.text?.value != null && controller.text.value.isNotEmpty
            ? controller.text.value
            : 'Text',
        textColor: controller.setTextError == true
            ? Theme.of(context).customColors().error
            : null,
        icon: SvgIcons.description,
        onTap: () => Get.toNamed('NewDiscussionTextScreen',
            arguments: {'controller': controller}),
      ),
    );
  }
}