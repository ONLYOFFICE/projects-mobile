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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/comments/comment_editing_controller.dart';
import 'package:projects/domain/controllers/comments/item_controller/abstract_comment_item_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/html_text_editor.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/wrappers/platform_widget.dart';

class CommentEditingView extends StatelessWidget {
  const CommentEditingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentId = Get.arguments['commentId'] as String?;
    final commentBody = Get.arguments['commentBody'] as String?;
    final itemController = Get.arguments['itemController'] as CommentItemController?;

    final controller = Get.put(CommentEditingController(
      commentBody: commentBody,
      commentId: commentId,
      itemController: itemController,
    ));

    return WillPopScope(
      onWillPop: () async {
        await controller.leavePage();
        return false;
      },
      child: Scaffold(
        appBar: StyledAppBar(
          titleText: tr('commentEditing'),
          leadingWidth: 65,
          centerTitle: !GetPlatform.isAndroid,
          actions: [
            PlatformWidget(
              material: (_, __) => IconButton(
                icon: const Icon(Icons.check_rounded),
                onPressed: controller.confirm,
              ),
              cupertino: (_, __) => CupertinoButton(
                onPressed: controller.confirm,
                padding: const EdgeInsets.only(right: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  tr('done'),
                  style: TextStyleHelper.headline7(),
                ),
              ),
            )
          ],
          leading: PlatformWidget(
            cupertino: (_, __) => CupertinoButton(
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              onPressed: controller.leavePage,
              child: Text(
                tr('closeLowerCase'),
                style: TextStyleHelper.button(),
              ),
            ),
            material: (_, __) => IconButton(
              onPressed: controller.leavePage,
              icon: const Icon(Icons.close),
            ),
          ),
        ),
        body: Obx(
          () => HtmlTextEditor(
            hintText: tr('replyText'),
            hasError: controller.setTitleError.value,
            initialText: commentBody,
            textController: controller.textController,
          ),
        ),
      ),
    );
  }
}
