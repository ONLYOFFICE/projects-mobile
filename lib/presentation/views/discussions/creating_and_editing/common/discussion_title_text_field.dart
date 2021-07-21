import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class DiscussionTitleTextField extends StatelessWidget {
  final DiscussionActionsController controller;
  const DiscussionTitleTextField({
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
                color: Get.theme.colors().onBackground),
            cursorColor: Get.theme.colors().primary.withOpacity(0.87),
            decoration: InputDecoration(
                hintText: tr('discussionTitle'),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                hintStyle: TextStyleHelper.headline6(
                  color: controller.setTitleError == true
                      ? Get.theme.colors().colorError
                      : Get.theme.colors().onSurface.withOpacity(0.5),
                ),
                border: InputBorder.none)),
      ),
    );
  }
}
