import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class CommentTextField extends StatelessWidget {
  final controller;
  const CommentTextField({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
        maxLines: null,
        autofocus: true,
        controller: controller.textController,
        scrollPadding: const EdgeInsets.all(10),
        decoration: InputDecoration.collapsed(
          hintText: tr('replyText'),
          hintStyle: TextStyle(
              color: controller.setTitleError == true
                  ? Theme.of(context).customColors().error
                  : null),
        ),
      ),
    );
  }
}
