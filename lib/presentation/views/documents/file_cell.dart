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
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/security.dart';

import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/documents/documents_move_or_copy_view.dart';

class FileCell extends StatelessWidget {
  final int index;

  final PortalFile entity;
  final controller;

  const FileCell({
    Key key,
    @required this.entity,
    @required this.index,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () async {
        await controller.openFile(entity);
      },
      child: Container(
        height: 72,
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: Center(
                child: Obx(() {
                  if (controller.paginationController.data[index].fileType == 7)
                    return AppIcon(width: 20, height: 20, icon: SvgIcons.doc);
                  if (controller.paginationController.data[index].fileType == 5)
                    return AppIcon(width: 20, height: 20, icon: SvgIcons.table);

                  if (controller.paginationController.data[index].fileType == 1)
                    return AppIcon(
                      width: 20,
                      height: 20,
                      icon: SvgIcons.archive,
                      color: Get.theme.colors().onSurface,
                    );
                  if (controller.paginationController.data[index].fileType == 4)
                    return AppIcon(width: 20, height: 20, icon: SvgIcons.image);
                  if (controller.paginationController.data[index].fileType == 6)
                    return AppIcon(
                        width: 20, height: 20, icon: SvgIcons.presentation);

                  return AppIcon(
                      width: 20,
                      height: 20,
                      icon: SvgIcons.documents,
                      color: Get.theme.colors().onSurface.withOpacity(0.6));
                }),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(entity.title.replaceAll(' ', '\u00A0'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleHelper.projectTitle),
                  ),
                  Text(
                      '${formatedDate(entity.updated)} • ${entity.contentLength} • ${entity.createdBy.displayName}',
                      style: TextStyleHelper.caption(
                          color:
                              Get.theme.colors().onSurface.withOpacity(0.6))),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: PopupMenuButton(
                  onSelected: (value) => {
                    _onFilePopupMenuSelected(value, entity, context, controller)
                  },
                  icon: Icon(Icons.more_vert,
                      color: Get.theme.colors().onSurface.withOpacity(0.5)),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'open',
                        child: Text(tr('open')),
                      ),
                      PopupMenuItem(
                        value: 'copyLink',
                        child: Text(tr('copyLink')),
                      ),
                      PopupMenuItem(
                        value: 'download',
                        child: Text(tr('download')),
                      ),
                      if (Security.files.canEdit(entity))
                        PopupMenuItem(
                          value: 'copy',
                          child: Text(tr('copy')),
                        ),
                      if (Security.files.canDelete(entity))
                        PopupMenuItem(
                          value: 'move',
                          child: Text(tr('move')),
                        ),
                      if (Security.files.canEdit(entity))
                        PopupMenuItem(
                          value: 'rename',
                          child: Text(tr('rename')),
                        ),
                      if (Security.files.canDelete(entity))
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            tr('delete'),
                            style: TextStyleHelper.subtitle1(
                                color: Get.theme.colors().colorError),
                          ),
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

void _onFilePopupMenuSelected(
  value,
  PortalFile selectedFile,
  BuildContext context,
  controller,
) async {
  switch (value) {
    case 'copyLink':
      var portalDomain = controller.portalInfoController.portalUri;

      var link =
          '${portalDomain}Products/Files/DocEditor.aspx?fileid=${selectedFile.id.toString()}';

      if (link != null) {
        await Clipboard.setData(ClipboardData(text: link));
        MessagesHandler.showSnackBar(context: context, text: tr('linkCopied'));
      }
      break;
    case 'open':
      await controller.openFile(selectedFile);
      break;
    case 'download':
      await controller.downloadFile(selectedFile.viewUrl);
      break;
    case 'copy':
      Get.find<NavigationController>()
          .to(DocumentsMoveOrCopyView(), preventDuplicates: false, arguments: {
        'mode': 'copyFile',
        'target': selectedFile.id,
        'initialFolderId': controller.currentFolder,
        'refreshCalback': controller.refreshContent
      });
      break;
    case 'move':
      Get.find<NavigationController>()
          .to(DocumentsMoveOrCopyView(), preventDuplicates: false, arguments: {
        'mode': 'moveFile',
        'target': selectedFile.id,
        'initialFolderId': controller.currentFolder,
        'refreshCalback': controller.refreshContent
      });

      break;
    case 'rename':
      _renameFile(controller, selectedFile, context);
      break;
    case 'delete':
      var success = await controller.deleteFile(selectedFile);

      if (success) {
        MessagesHandler.showSnackBar(context: context, text: tr('fileDeleted'));
      }
      break;
    default:
  }
}

void _renameFile(
  controller,
  PortalFile element,
  BuildContext context,
) {
  var inputController = TextEditingController();
  inputController.text = element.title.replaceAll(element.fileExst, '');

  Get.dialog(
    StyledAlertDialog(
      titleText: tr('renameFile'),
      content: TextField(
        autofocus: true,
        textInputAction: TextInputAction.search,
        controller: inputController,
        decoration: InputDecoration.collapsed(hintText: tr('enterFileName')),
        onSubmitted: (value) {
          controller.newSearch(value);
        },
      ),
      acceptText: tr('confirm'),
      cancelText: tr('cancel'),
      onAcceptTap: () async {
        if (inputController.text != element.title) {
          var success =
              await controller.renameFile(element, inputController.text);
          if (success) {
            MessagesHandler.showSnackBar(
                context: context, text: tr('fileRenamed'));
            Get.back();
          }
        } else
          Get.back();
      },
      onCancelTap: Get.back,
    ),
  );
}
