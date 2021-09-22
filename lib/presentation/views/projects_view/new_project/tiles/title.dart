import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class ProjectTitleTile extends StatelessWidget {
  final controller;
  final bool showCaption;
  final bool focusOnTitle;
  const ProjectTitleTile({
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
                Text('${tr('projectTitle')}:',
                    style: TextStyleHelper.caption(
                        color:
                            Get.theme.colors().onBackground.withOpacity(0.75))),
              TextField(
                  focusNode: focusOnTitle ? controller.titleFocus : null,
                  maxLines: null,
                  controller: controller.titleController,
                  style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onBackground),
                  cursorColor: Get.theme.colors().primary.withOpacity(0.87),
                  decoration: InputDecoration(
                      hintText: tr('projectTitle'),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      hintStyle: TextStyleHelper.headline6(
                          color: controller.needToFillTitle.value == true
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
