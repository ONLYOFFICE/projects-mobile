import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/abstract_discussion_actions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class NewDiscussionTitle extends StatelessWidget {
  final DiscussionActionsController controller;
  const NewDiscussionTitle({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 72, right: 16, top: 16, bottom: 34),
      child: Obx(
        () => TextField(
            focusNode: controller.titleFocus,
            maxLines: null,
            controller: controller.titleController,
            onChanged: controller.changeTitle,
            style: TextStyleHelper.headline6(
                color: Theme.of(context).customColors().onBackground),
            cursorColor:
                Theme.of(context).customColors().primary.withOpacity(0.87),
            decoration: InputDecoration(
                hintText: 'Discussion title',
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                hintStyle: TextStyleHelper.headline6(
                  color: controller.setTitleError == true
                      ? Theme.of(context).customColors().error
                      : Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.5),
                ),
                border: InputBorder.none)),
      ),
    );
  }
}
