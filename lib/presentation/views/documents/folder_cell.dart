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
import 'package:event_hub/event_hub.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/domain/controllers/documents/base_documents_controller.dart';
import 'package:projects/domain/controllers/documents/documents_move_or_copy_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/security.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/context_menu/platform_context_menu_button.dart';
import 'package:projects/presentation/shared/widgets/context_menu/platform_context_menu_item.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/documents/documents_move_or_copy_view.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';

class FolderCell extends StatelessWidget {
  const FolderCell({
    Key? key,
    required this.entity,
    required this.controller,
  }) : super(key: key);

  final Folder entity;
  final BaseDocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<NavigationController>().to(FolderContentView(),
            preventDuplicates: false,
            arguments: {'folderName': entity.title, 'folderId': entity.id});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 72,
        child: Row(
          children: [
            const FolderCellAvatar(),
            Expanded(child: FolderCellTitle(element: entity)),
            const SizedBox(width: 16),
            PlatformPopupMenuButton(
              padding: EdgeInsets.zero,
              onSelected: (dynamic value) => _onFolderPopupMenuSelected(
                value,
                entity,
                context,
                controller,
              ),
              icon: Icon(PlatformIcons(context).ellipsis,
                  color: Theme.of(context).colors().onSurface.withOpacity(0.5)),
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
                  if (Security.documents.canEdit(entity))
                    PlatformPopupMenuItem(
                      value: 'copy',
                      child: Text(tr('copy')),
                    ),
                  if (!Security.documents.isRoot(entity) && Security.documents.canDelete(entity))
                    PlatformPopupMenuItem(
                      value: 'move',
                      child: Text(tr('move')),
                    ),
                  if (!Security.documents.isRoot(entity) && Security.documents.canEdit(entity))
                    PlatformPopupMenuItem(
                      value: 'rename',
                      child: Text(tr('rename')),
                    ),
                  if (!Security.documents.isRoot(entity) && Security.documents.canDelete(entity))
                    PlatformPopupMenuItem(
                      value: 'delete',
                      isDestructiveAction: true,
                      textStyle:
                          TextStyleHelper.subtitle1(color: Theme.of(context).colors().colorError),
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

class MoveFolderCell extends StatelessWidget {
  const MoveFolderCell({
    Key? key,
    required this.element,
    required this.controller,
  }) : super(key: key);

  final Folder element;
  final DocumentsMoveOrCopyController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<NavigationController>().toScreen(
          DocumentsMoveOrCopyView(),
          preventDuplicates: false,
          arguments: {
            'mode': controller.mode,
            'target': controller.target,
            'currentFolder': element,
            'initialFolderId': controller.initialFolderId,
            'nestingCounter': controller.nestingCounter,
          },
          transition: Transition.rightToLeft,
          page: '/DocumentsMoveOrCopyView',
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 72,
        child: Row(
          children: [
            const FolderCellAvatar(),
            Expanded(child: FolderCellTitle(element: element)),
            const SizedBox(width: 16)
          ],
        ),
      ),
    );
  }
}

class FolderCellAvatar extends StatelessWidget {
  const FolderCellAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Center(
        child: AppIcon(
          width: 20,
          height: 20,
          color: Theme.of(context).colors().onSurface.withOpacity(0.8),
          icon: SvgIcons.folder,
        ),
      ),
    );
  }
}

class FolderCellTitle extends StatelessWidget {
  const FolderCellTitle({
    Key? key,
    required this.element,
  }) : super(key: key);

  final Folder element;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            element.title!.replaceAll(' ', '\u00A0'),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyleHelper.subtitle1(),
          ),
        ),
        Text(
          tr(
            'documentsCaption',
            args: [
              formatedDate(element.updated!),
              element.filesCount.toString(),
              element.foldersCount.toString()
            ],
          ),
          // '${formatedDate(element.updated)} • documents:${element.filesCount} • subfolders:${element.foldersCount}',
          style: TextStyleHelper.caption(
            color: Theme.of(context).colors().onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

Future<void> _onFolderPopupMenuSelected(
  value,
  Folder selectedFolder,
  BuildContext context,
  dynamic controller,
) async {
  switch (value) {
    case 'copyLink':
      final portalDomain = controller.portalInfoController.portalUri;

      if (portalDomain != null && selectedFolder.id != null) {
        final link = '$portalDomain/Products/Files/#${selectedFolder.id.toString()}';

        if (link.isURL) {
          await Clipboard.setData(ClipboardData(text: link));
          MessagesHandler.showSnackBar(context: Get.context!, text: tr('linkCopied'));
        } else
          MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
      }
      break;
    case 'open':
      await Get.find<NavigationController>().to(FolderContentView(),
          preventDuplicates: false,
          arguments: {'folderName': selectedFolder.title, 'folderId': selectedFolder.id});
      break;
    case 'copy':
      await Get.find<NavigationController>().toScreen(
        DocumentsMoveOrCopyView(),
        preventDuplicates: false,
        arguments: {
          'mode': MoveOrCopyMode.CopyFolder,
          'target': selectedFolder.id,
          'initialFolderId': controller.currentFolderID,
        },
        transition: Transition.rightToLeft,
        page: '/DocumentsMoveOrCopyView',
      );
      break;
    case 'move':
      await Get.find<NavigationController>().toScreen(
        DocumentsMoveOrCopyView(),
        preventDuplicates: false,
        arguments: {
          'mode': MoveOrCopyMode.MoveFolder,
          'target': selectedFolder.id,
          'initialFolderId': controller.currentFolderID,
        },
        transition: Transition.rightToLeft,
        page: '/DocumentsMoveOrCopyView',
      );

      break;
    case 'rename':
      _renameFolder(controller, selectedFolder, context);
      break;
    case 'delete':
      final error = await controller.deleteFolder(selectedFolder);

      if (error == null) {
        MessagesHandler.showSnackBar(context: Get.context!, text: tr('folderDeleted'));

        locator<EventHub>().fire('needToRefreshDocuments');
      } else
        MessagesHandler.showSnackBar(context: Get.context!, text: tr('folderDeleted'));
      break;
    default:
  }
}

void _renameFolder(dynamic controller, Folder element, BuildContext context) {
  final inputController = TextEditingController();
  inputController.text = element.title!;

  final isErrorInputText = ValueNotifier<bool>(false);

  Get.find<NavigationController>().showPlatformDialog(
    StyledAlertDialog(
      titleText: tr('renameFolder'),
      content: ValueListenableBuilder<bool>(
        valueListenable: isErrorInputText,
        builder: (_, __, ___) => _NameFolderTextFieldWidget(
          inputController: inputController,
          controller: controller,
          element: element,
          isErrorInputText: isErrorInputText,
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
          if (inputController.text != element.title) {
            final success = await controller.renameFolder(element, inputController.text) as bool;
            if (success) {
              Get.back();
              MessagesHandler.showSnackBar(context: Get.context!, text: tr('folderRenamed'));
            } else
              MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
          }
        }
      },
      onCancelTap: Get.back,
    ),
  );
}

class _NameFolderTextFieldWidget extends StatelessWidget {
  const _NameFolderTextFieldWidget({
    Key? key,
    required this.inputController,
    required this.controller,
    required this.element,
    required this.isErrorInputText,
  }) : super(key: key);

  final TextEditingController inputController;
  final dynamic controller;
  final Folder element;
  final ValueNotifier<bool> isErrorInputText;

  @override
  Widget build(BuildContext context) {
    return PlatformTextField(
      makeCupertinoDecorationNull: true,
      autofocus: true,
      textInputAction: TextInputAction.done,
      controller: inputController,
      hintText: tr('enterFolderName'),
      style: TextStyleHelper.body2(color: Theme.of(context).colors().onSurface),
      cupertino: (_, __) => CupertinoTextFieldData(
        decoration: BoxDecoration(
          color: Theme.of(context).colors().background,
          borderRadius: BorderRadius.circular(5),
        ),
        placeholderStyle: TextStyleHelper.body2(
          color: isErrorInputText.value
              ? Theme.of(context).colors().colorError
              : Theme.of(context).colors().onSurface.withOpacity(0.5),
        ),
      ),
      material: (_, __) => MaterialTextFieldData(
        decoration: InputDecoration.collapsed(
          hintText: tr('enterFolderName'),
          fillColor: Theme.of(context).colors().background,
          hintStyle: TextStyleHelper.body2(
            color: isErrorInputText.value
                ? Theme.of(context).colors().colorError
                : Theme.of(context).colors().onSurface.withOpacity(0.5),
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
          if (inputController.text != element.title) {
            final success = await controller.renameFolder(element, inputController.text) as bool;
            if (success) {
              Get.back();
              MessagesHandler.showSnackBar(context: Get.context!, text: tr('folderRenamed'));
            } else
              MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
          }
        }
      },
    );
  }
}
