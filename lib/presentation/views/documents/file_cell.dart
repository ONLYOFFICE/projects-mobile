import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/domain/controllers/documents/discussions_documents_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/documents/documents_move_or_copy_view.dart';

class FileCell extends StatelessWidget {
  final int index;

  final PortalFile element;
  final controller;

  const FileCell({
    Key key,
    @required this.element,
    @required this.index,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: Text(element.title.replaceAll(' ', '\u00A0'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleHelper.projectTitle),
                ),
                Text(
                    '${formatedDate(element.updated)} • ${element.contentLength} • ${element.updatedBy.displayName}',
                    style: TextStyleHelper.caption(
                        color: Get.theme.colors().onSurface.withOpacity(0.6))),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: PopupMenuButton(
                onSelected: (value) => {
                  _onFilePopupMenuSelected(value, element, context, controller)
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
                    if (!(controller is DiscussionsDocumentsController))
                      PopupMenuItem(
                        value: 'copy',
                        child: Text(tr('copy')),
                      ),
                    if (!(controller is DiscussionsDocumentsController))
                      PopupMenuItem(
                        value: 'move',
                        child: Text(tr('move')),
                      ),
                    if (!(controller is DiscussionsDocumentsController))
                      PopupMenuItem(
                        value: 'rename',
                        child: Text(tr('rename')),
                      ),
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
        Future.delayed(const Duration(milliseconds: 500),
            () => controller.refreshContent());
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
            await controller.refreshContent();
          }
        } else
          Get.back();
      },
      onCancelTap: Get.back,
    ),
  );
}
