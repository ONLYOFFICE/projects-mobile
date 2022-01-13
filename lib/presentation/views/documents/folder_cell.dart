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
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/documents/documents_move_or_copy_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/security.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_item.dart';
import 'package:projects/presentation/shared/wrappers/platform_text_field.dart';
import 'package:projects/presentation/views/documents/documents_move_or_copy_view.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';

class FolderCell extends StatelessWidget {
  const FolderCell({
    Key? key,
    required this.entity,
    required this.controller,
  }) : super(key: key);

  final Folder entity;
  final DocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        Get.find<NavigationController>().to(FolderContentView(),
            preventDuplicates: false,
            arguments: {'folderName': entity.title, 'folderId': entity.id});
      },
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            const FolderCellAvatar(),
            FolderCellTitle(element: entity),
            SizedBox(
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: PlatformPopupMenuButton(
                  onSelected: (dynamic value) => _onFolderPopupMenuSelected(
                    value,
                    entity,
                    context,
                    controller,
                  ),
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
                      if (Security.documents.canEdit(entity))
                        PlatformPopupMenuItem(
                          value: 'copy',
                          child: Text(tr('copy')),
                        ),
                      if (!Security.documents.isRoot(entity) &&
                          Security.documents.canDelete(entity))
                        PlatformPopupMenuItem(
                          value: 'move',
                          child: Text(tr('move')),
                        ),
                      if (!Security.documents.isRoot(entity) && Security.documents.canEdit(entity))
                        PlatformPopupMenuItem(
                          value: 'rename',
                          child: Text(tr('rename')),
                        ),
                      if (!Security.documents.isRoot(entity) &&
                          Security.documents.canDelete(entity))
                        PlatformPopupMenuItem(
                          value: 'delete',
                          isDestructiveAction: true,
                          textStyle:
                              TextStyleHelper.subtitle1(color: Get.theme.colors().colorError),
                          child: Text(tr('delete')),
                        ),
                    ];
                  },
                ),
              ),
            ),
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
    return InkResponse(
      onTap: () {
        final target = controller.target;
        Get.find<NavigationController>()
            .to(MoveFolderContentView(), preventDuplicates: false, arguments: {
          'mode': controller.mode,
          'target': target,
          'currentFolder': element,
          'initialFolderId': controller.initialFolderId,
          'foldersCount': controller.foldersCount,
        });
      },
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            const FolderCellAvatar(),
            FolderCellTitle(element: element),
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
          color: Get.theme.colors().onSurface.withOpacity(0.8),
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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(element.title!.replaceAll(' ', '\u00A0'),
                maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyleHelper.projectTitle),
          ),
          Text(
              tr('documentsCaption', args: [
                formatedDate(element.updated!),
                element.filesCount.toString(),
                element.foldersCount.toString()
              ]),
              // '${formatedDate(element.updated)} • documents:${element.filesCount} • subfolders:${element.foldersCount}',
              style: TextStyleHelper.caption(color: Get.theme.colors().onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }
}

Future<void> _onFolderPopupMenuSelected(
  value,
  Folder selectedFolder,
  BuildContext context,
  DocumentsController controller,
) async {
  switch (value) {
    case 'copyLink':
      final portalDomain = controller.portalInfoController.portalUri;

      if (portalDomain != null && selectedFolder.id != null) {
        final link = '${portalDomain}Products/Files/#${selectedFolder.id.toString()}';

        await Clipboard.setData(ClipboardData(text: link));
        MessagesHandler.showSnackBar(context: context, text: tr('linkCopied'));
      }
      break;
    case 'open':
      Get.find<NavigationController>().to(FolderContentView(),
          preventDuplicates: false,
          arguments: {'folderName': selectedFolder.title, 'folderId': selectedFolder.id});
      break;
    case 'copy':
      Get.find<NavigationController>()
          .to(DocumentsMoveOrCopyView(), preventDuplicates: false, arguments: {
        'mode': 'copyFolder',
        'target': selectedFolder.id,
        'initialFolderId': controller.currentFolderID,
      });
      break;
    case 'move':
      Get.find<NavigationController>()
          .to(DocumentsMoveOrCopyView(), preventDuplicates: false, arguments: {
        'mode': 'moveFolder',
        'target': selectedFolder.id,
        'initialFolderId': controller.currentFolderID,
      });

      break;
    case 'rename':
      _renameFolder(controller, selectedFolder, context);
      break;
    case 'delete':
      final success = await controller.deleteFolder(selectedFolder);

      if (success) {
        MessagesHandler.showSnackBar(context: context, text: tr('folderDeleted'));
      }
      break;
    default:
  }
}

void _renameFolder(DocumentsController? controller, Folder element, BuildContext context) {
  final inputController = TextEditingController();
  inputController.text = element.title!;

  Get.dialog(
    StyledAlertDialog(
      titleText: tr('renameFolder'),
      content: PlatformTextField(
        autofocus: true,
        textInputAction: TextInputAction.search,
        controller: inputController,
        decoration: InputDecoration.collapsed(
          hintText: tr('enterFolderName'),
        ),
        onSubmitted: (value) {
          controller!.newSearch(value);
        },
      ),
      acceptText: tr('confirm'),
      cancelText: tr('cancel'),
      onAcceptTap: () async {
        if (inputController.text != element.title) {
          final success = await controller!.renameFolder(element, inputController.text);
          if (success) {
            MessagesHandler.showSnackBar(context: context, text: tr('folderRenamed'));
            Get.back();
            await controller.refreshContent();
          }
        } else
          Get.back();
      },
      onCancelTap: Get.back,
    ),
  );
}
