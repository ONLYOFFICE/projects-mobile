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
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/internal/utils/html_parser.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/new_item_tile.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/discussion_text_screen.dart';

class DiscussionTextTile extends StatelessWidget {
  final DiscussionActionsController? controller;
  const DiscussionTextTile({
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NewItemTile(
        text: controller!.text?.value != null && controller!.text!.value.isNotEmpty
            ? parseHtml(controller!.text!.value)
            : tr('text'),
        textColor:
            controller!.setTextError == true && controller!.text!.value.isEmpty
                ? Get.theme.colors().colorError
                : null,
        isSelected:
            controller!.text?.value != null && controller!.text!.value.isNotEmpty,
        icon: SvgIcons.description,
        selectedIconColor: Get.theme.colors().onSurface.withOpacity(0.8),
        onTap: () => Get.find<NavigationController>().toScreen(
            NewDiscussionTextScreen(controller: controller),
            arguments: {'controller': controller}),
      ),
    );
  }
}
