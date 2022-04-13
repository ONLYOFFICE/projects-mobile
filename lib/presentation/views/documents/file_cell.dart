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
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/documents/base_documents_controller.dart';
import 'package:projects/domain/controllers/documents/discussions_documents_controller.dart';
import 'package:projects/domain/controllers/documents/documents_move_or_copy_controller.dart';

import 'package:projects/domain/controllers/documents/file_cell_controller.dart';

import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/security.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_item.dart';
import 'package:projects/presentation/shared/wrappers/platform_text_field.dart';
import 'package:projects/presentation/views/documents/documents_move_or_copy_view.dart';

class FileCell extends StatelessWidget {
  final FileCellController cellController;
  final BaseDocumentsController documentsController;

  const FileCell({Key? key, required this.documentsController, required this.cellController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await cellController.openFile(cellController.file);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 72,
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: Center(
                child: Obx(() => cellController.fileIcon.value),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(cellController.file.title!.replaceAll(' ', '\u00A0'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleHelper.subtitle1()),
                  ),
                  Text(
                      '${formatedDate(cellController.file.updated!)} • ${cellController.file.contentLength} • ${cellController.file.createdBy!.displayName}',
                      style: TextStyleHelper.caption(
                          color: Get.theme.colors().onSurface.withOpacity(0.6))),
                ],
              ),
            ),
            const SizedBox(width: 16),
            PlatformPopupMenuButton(
              padding: EdgeInsets.zero,
              onSelected: (dynamic value) =>
                  {_onFilePopupMenuSelected(value, context, documentsController, cellController)},
              icon: Icon(PlatformIcons(context).ellipsis,
                  color: Get.theme.colors().onSurface.withOpacity(0.5)),
              itemBuilder: (context) {
                return [
                  PlatformPopupMenuItem(
                    value: 'open',
                    child: Text(tr('open')),
                  ),
                  PlatformPopupMenuItem(
                    value: 'copyLink',
                    child: Text(tr('copyLink')),
                  ),
                  PlatformPopupMenuItem(
                    value: 'download',
                    child: Text(tr('download')),
                  ),
                  if (Security.files.canEdit(cellController.file) &&
                      documentsController is! DiscussionsDocumentsController)
                    PlatformPopupMenuItem(
                      value: 'copy',
                      child: Text(tr('copy')),
                    ),
                  if (Security.files.canDelete(cellController.file) &&
                      documentsController is! DiscussionsDocumentsController)
                    PlatformPopupMenuItem(
                      value: 'move',
                      child: Text(tr('move')),
                    ),
                  if (Security.files.canEdit(cellController.file) &&
                      documentsController is! DiscussionsDocumentsController)
                    PlatformPopupMenuItem(
                      value: 'rename',
                      child: Text(tr('rename')),
                    ),
                  if (Security.files.canDelete(cellController.file))
                    PlatformPopupMenuItem(
                      value: 'delete',
                      isDestructiveAction: true,
                      textStyle: TextStyleHelper.subtitle1(color: Get.theme.colors().colorError),
                      child: Text(tr('delete')),
                    ),
                ];
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

Future<void> _onFilePopupMenuSelected(value, BuildContext context,
    BaseDocumentsController documentsController, FileCellController cellController) async {
  switch (value) {
    case 'copyLink':
      final portalDomain = documentsController.portalInfoController.portalUri;

      if (portalDomain != null && cellController.file.id != null) {
        final link =
            '$portalDomain/Products/Files/DocEditor.aspx?fileid=${cellController.file.id.toString()}';

        if (link.isURL) {
          await Clipboard.setData(ClipboardData(text: link));
          MessagesHandler.showSnackBar(context: Get.context!, text: tr('linkCopied'));
        } else
          MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
      }
      break;
    case 'open':
      await cellController.openFile(cellController.file);
      break;
    case 'download':
      await cellController.downloadFile(cellController.file.viewUrl!);
      break;
    case 'copy':
      await Get.find<NavigationController>().toScreen(
        DocumentsMoveOrCopyView(),
        preventDuplicates: false,
        arguments: {
          'mode': MoveOrCopyMode.CopyDocument,
          'target': cellController.file.id,
          'initialFolderId': documentsController.currentFolderID,
        },
        transition: Transition.rightToLeft,
      );
      break;
    case 'move':
      await Get.find<NavigationController>().toScreen(
        DocumentsMoveOrCopyView(),
        preventDuplicates: false,
        arguments: {
          'mode': MoveOrCopyMode.MoveDocument,
          'target': cellController.file.id,
          'initialFolderId': documentsController.currentFolderID,
        },
        transition: Transition.rightToLeft,
      );
      break;
    case 'rename':
      _renameFile(documentsController, cellController, context);
      break;
    case 'delete':
      final success = await cellController.deleteFile(cellController.file);

      if (success) {
        MessagesHandler.showSnackBar(context: Get.context!, text: tr('fileDeleted'));
      } else
        MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
      break;
    default:
  }
}

void _renameFile(
  BaseDocumentsController docController,
  FileCellController cellController,
  BuildContext context,
) {
  final inputController = TextEditingController();
  inputController.text = cellController.file.title!.replaceAll(cellController.file.fileExst!, '');

  final isErrorInputText = ValueNotifier<bool>(false);

  Get.dialog(
    StyledAlertDialog(
      titleText: tr('renameFile'),
      content: ValueListenableBuilder<bool>(
        valueListenable: isErrorInputText,
        builder: (_, __, ___) => _NewFileTextFieldWidget(
          inputController: inputController,
          docController: docController,
          isErrorInputText: isErrorInputText,
          cellController: cellController,
        ),
      ),
      acceptText: tr('confirm'),
      cancelText: tr('cancel'),
      onAcceptTap: () async {
        inputController.text = inputController.text.trim();
        inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: inputController.text.length),
        );

        if (inputController.text.isEmpty) {
          isErrorInputText.value = true;
        } else {
          if (inputController.text != cellController.file.title) {
            final success =
                await cellController.renameFile(cellController.file, inputController.text);
            if (success) {
              Get.back();
              MessagesHandler.showSnackBar(context: Get.context!, text: tr('fileRenamed'));
            } else
              MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
          }
        }
      },
      onCancelTap: Get.back,
    ),
  );
}

class _NewFileTextFieldWidget extends StatelessWidget {
  const _NewFileTextFieldWidget({
    Key? key,
    required this.inputController,
    required this.docController,
    required this.isErrorInputText,
    required this.cellController,
  }) : super(key: key);

  final TextEditingController inputController;
  final BaseDocumentsController docController;
  final ValueNotifier<bool> isErrorInputText;
  final FileCellController cellController;

  @override
  Widget build(BuildContext context) {
    return PlatformTextField(
      autofocus: true,
      style: TextStyleHelper.body2(color: Get.theme.colors().onSurface),
      textInputAction: TextInputAction.done,
      controller: inputController,
      makeCupertinoDecorationNull: false,
      hintText: tr('enterFileName'),
      cupertino: (_, __) => CupertinoTextFieldData(
        decoration: BoxDecoration(
          color: Get.theme.colors().background,
          borderRadius: BorderRadius.circular(5),
        ),
        placeholderStyle: TextStyleHelper.body2(
          color: isErrorInputText.value
              ? Get.theme.colors().colorError
              : Get.theme.colors().onSurface.withOpacity(0.5),
        ),
      ),
      material: (_, __) => MaterialTextFieldData(
        decoration: InputDecoration.collapsed(
          hintText: tr('enterFileName'),
          fillColor: Get.theme.colors().background,
          hintStyle: TextStyleHelper.body2(
            color: isErrorInputText.value
                ? Get.theme.colors().colorError
                : Get.theme.colors().onSurface.withOpacity(0.5),
          ),
        ),
      ),
      onChanged: (value) {
        if (isErrorInputText.value && value.isNotEmpty) {
          isErrorInputText.value = false;
        }
      },
      onSubmitted: (_) async {
        inputController.text = inputController.text.trim();
        inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: inputController.text.length),
        );

        if (inputController.text.isEmpty) {
          isErrorInputText.value = true;
        } else {
          if (inputController.text != cellController.file.title) {
            final success =
                await cellController.renameFile(cellController.file, inputController.text);
            if (success) {
              Get.back();
              MessagesHandler.showSnackBar(context: Get.context!, text: tr('fileRenamed'));
            } else
              MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
          }
        }
      },
    );
  }
}
