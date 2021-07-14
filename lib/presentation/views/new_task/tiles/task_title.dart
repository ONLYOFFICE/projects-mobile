import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/abstract_task_actions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class TaskTitle extends StatelessWidget {
  final TaskActionsController controller;
  final bool showCaption;
  final bool focusOnTitle;
  const TaskTitle({
    Key key,
    @required this.controller,
    this.showCaption = false,
    this.focusOnTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Padding(
          padding: const EdgeInsets.only(left: 72, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showCaption)
                Text('${tr('taskTitle')}:',
                    style: TextStyleHelper.caption(
                        color:
                            Get.theme.colors().onBackground.withOpacity(0.75))),
              TextField(
                  focusNode: focusOnTitle ? controller.titleFocus : null,
                  maxLines: null,
                  controller: controller.titleController,
                  onChanged: controller.changeTitle,
                  style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onBackground),
                  cursorColor: Get.theme.colors().primary.withOpacity(0.87),
                  decoration: InputDecoration(
                      hintText: tr('taskTitle'),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      hintStyle: TextStyleHelper.headline6(
                          color: controller.setTitleError.isTrue
                              ? Get.theme.colors().colorError
                              : Get.theme.colors().onSurface.withOpacity(0.5)),
                      border: InputBorder.none)),
              const SizedBox(height: 10)
            ],
          ),
        );
      },
    );
  }
}
