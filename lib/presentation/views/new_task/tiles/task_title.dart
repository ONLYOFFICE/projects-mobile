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
          padding: const EdgeInsets.only(left: 56, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showCaption)
                Text('Task title:',
                    style: TextStyleHelper.caption(
                        color: Theme.of(context)
                            .customColors()
                            .onBackground
                            .withOpacity(0.75))),
              TextField(
                  focusNode: focusOnTitle ? controller.titleFocus : null,
                  maxLines: null,
                  controller: controller.titleController,
                  onChanged: controller.changeTitle,
                  style: TextStyleHelper.headline6(
                      color: Theme.of(context).customColors().onBackground),
                  cursorColor: Theme.of(context)
                      .customColors()
                      .primary
                      .withOpacity(0.87),
                  decoration: InputDecoration(
                      hintText: 'Task title',
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      hintStyle: TextStyleHelper.headline6(
                          color: controller.setTitleError.isTrue
                              ? Theme.of(context).customColors().error
                              : Theme.of(context)
                                  .customColors()
                                  .onSurface
                                  .withOpacity(0.5)),
                      border: InputBorder.none)),
              const SizedBox(height: 10)
            ],
          ),
        );
      },
    );
  }
}
