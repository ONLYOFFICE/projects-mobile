/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_text_field.dart';

class ProjectTitleTile extends StatelessWidget {
  final BaseProjectEditorController controller;
  final bool showCaption;
  final bool focusOnTitle;
  const ProjectTitleTile({
    Key? key,
    required this.controller,
    this.showCaption = false,
    this.focusOnTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 10, top: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SizedBox(
              width: 72,
              child: Obx(
                () => AppIcon(
                  icon: SvgIcons.project,
                  color: controller.titleIsEmpty.value
                      ? Get.theme.colors().onBackground.withOpacity(0.4)
                      : Get.theme.colors().onBackground.withOpacity(0.75),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showCaption)
                  Text('${tr('projectTitle')}:',
                      style: TextStyleHelper.caption(
                          color: Get.theme.colors().onBackground.withOpacity(0.75))),
                Obx(() {
                  final needToFillTitle = controller.needToFillTitle.value;
                  return PlatformTextField(
                    focusNode: focusOnTitle ? controller.titleFocus : null,
                    maxLines: null,
                    controller: controller.titleController,
                    style: TextStyleHelper.headline6(color: Get.theme.colors().onBackground),
                    cursorColor: Get.theme.colors().primary.withOpacity(0.87),
                    hintText: tr('projectTitle'),
                    cupertino: (_, __) => CupertinoTextFieldData(
                      padding: EdgeInsets.zero,
                      placeholderStyle: TextStyleHelper.headline6(
                          color: needToFillTitle
                              ? Get.theme.colors().colorError
                              : Get.theme.colors().onSurface.withOpacity(0.5)),
                    ),
                    material: (_, __) => MaterialTextFieldData(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintStyle: TextStyleHelper.headline6(
                              color: needToFillTitle
                                  ? Get.theme.colors().colorError
                                  : Get.theme.colors().onSurface.withOpacity(0.5)),
                          border: InputBorder.none),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
