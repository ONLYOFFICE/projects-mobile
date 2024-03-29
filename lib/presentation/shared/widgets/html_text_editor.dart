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
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlTextEditor extends StatelessWidget {
  const HtmlTextEditor({
    Key? key,
    this.height,
    this.hintText,
    this.hasError = false,
    this.initialText = '',
    required this.textController,
  }) : super(key: key);

  final HtmlEditorController textController;
  final String? hintText;
  final String? initialText;
  final double? height;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return HtmlEditor(
      controller: textController,
      callbacks: Callbacks(onNavigationRequestMobile: (url) {
        launch(url);
        return NavigationActionPolicy.CANCEL;
      }),
      htmlToolbarOptions: HtmlToolbarOptions(
        mediaUploadInterceptor: (file, type) async {
          textController.setFocus();
          final result = await locator<CommentsService>().uploadImages(file);
          if (result != null && result.isURL)
            textController.insertNetworkImage(result);
          else
            MessagesHandler.showSnackBar(context: Get.context!, text: result ?? tr('error'));

          return false;
        },
        linkInsertInterceptor: (text, url, isNewWindow) {
          textController.setFocus();
          textController.insertLink(text, url, isNewWindow);
          return false;
        },
        mediaLinkInsertInterceptor: (link, type) {
          textController.setFocus();
          return true;
        },
        textStyle: TextStyleHelper.body2(color: Theme.of(context).colors().onBackground),
        defaultToolbarButtons: const [
          StyleButtons(),
          FontSettingButtons(fontSizeUnit: false),
          FontButtons(
            clearAll: false,
            subscript: false,
            superscript: false,
          ),
          // they don't work
          ColorButtons(foregroundColor: false, highlightColor: false),
          ListButtons(listStyles: false),
          ParagraphButtons(
            textDirection: false,
            lineHeight: false,
            caseConverter: false,
          ),
          InsertButtons(
            video: false,
            audio: false,
            table: false,
            hr: false,
          ),
        ],
      ),
      htmlEditorOptions: HtmlEditorOptions(
        hint: hintText,
        initialText: initialText,
      ),
      otherOptions: OtherOptions(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colors().colorError,
            width: 2,
            style: hasError ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        height: Get.height,
      ),
    );
  }
}
