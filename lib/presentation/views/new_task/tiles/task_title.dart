import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class TaskTitle extends StatelessWidget {
  final controller;
  const TaskTitle({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Padding(
          padding: const EdgeInsets.only(left: 56, right: 16),
          child: TextField(
              autofocus: controller.title.isEmpty,
              maxLines: 2,
              onChanged: (value) => controller.changeTitle(value),
              style: TextStyleHelper.headline6(
                  color: Theme.of(context).customColors().onBackground),
              cursorColor:
                  Theme.of(context).customColors().primary.withOpacity(0.87),
              decoration: InputDecoration(
                  hintText: 'Task title',
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  hintStyle: TextStyleHelper.headline6(
                      color: Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.5)),
                  border: InputBorder.none)),
        );
      },
    );
  }
}
