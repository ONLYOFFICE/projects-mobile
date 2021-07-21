import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';

class DiscussionProjectTile extends StatelessWidget {
  final DiscussionActionsController controller;
  final bool ignoring;
  const DiscussionProjectTile({
    Key key,
    this.controller,
    this.ignoring = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IgnorePointer(
        ignoring: ignoring,
        child: NewTaskInfo(
          icon: SvgIcons.project,
          text: controller.selectedProjectTitle.value.isNotEmpty
              ? controller.selectedProjectTitle.value
              : tr('chooseProject'),
          textColor: controller.selectProjectError == true
              ? Get.theme.colors().colorError
              : null,
          onTap: () => Get.toNamed('SelectProjectView',
              arguments: {'controller': controller}),
        ),
      ),
    );
  }
}
