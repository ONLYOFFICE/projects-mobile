import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/domain/controllers/documents/discussions_documents_controller.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/documents/documents_move_or_copy_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/documents/documents_move_or_copy_view.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';

class FolderCell extends StatelessWidget {
  const FolderCell({
    Key key,
    @required this.element,
    @required this.controller,
  }) : super(key: key);

  final Folder element;
  final controller;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        Get.find<NavigationController>().to(FolderContentView(),
            preventDuplicates: false,
            arguments: {'folderName': element.title, 'folderId': element.id});
      },
      child: Container(
        height: 72,
        child: Row(
          children: [
            const FolderCellAvatar(),
            FolderCellTitle(element: element),
            SizedBox(
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: PopupMenuButton(
                  onSelected: (value) => _onFolderPopupMenuSelected(
                    value,
                    element,
                    context,
                    controller,
                  ),
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
                      if (controller.canCopy)
                        PopupMenuItem(
                          value: 'copy',
                          child: Text(tr('copy')),
                        ),
                      if (_isRoot(element) && controller.canMove)
                        PopupMenuItem(
                          value: 'move',
                          child: Text(tr('move')),
                        ),
                      if (_isRoot(element) && controller.canRename)
                        PopupMenuItem(
                          value: 'rename',
                          child: Text(tr('rename')),
                        ),
                      if (_isRoot(element) && controller.canDelete)
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

class MoveFolderCell extends StatelessWidget {
  const MoveFolderCell({
    Key key,
    @required this.element,
    @required this.controller,
  }) : super(key: key);

  final Folder element;
  final DocumentsMoveOrCopyController controller;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        var target = controller.target;
        Get.find<NavigationController>()
            .to(MoveFolderContentView(), preventDuplicates: false, arguments: {
          'mode': controller.mode,
          'target': target,
          'currentFolder': element,
          'initialFolderId': controller.initialFolderId,
          'foldersCount': controller.foldersCount,
        });
      },
      child: Container(
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
    Key key,
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
    Key key,
    @required this.element,
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
            child: Text(element.title.replaceAll(' ', '\u00A0'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyleHelper.projectTitle),
          ),
          Text(
              tr('documentsCaption', args: [
                formatedDate(element.updated),
                element.filesCount.toString(),
                element.foldersCount.toString()
              ]),
              // '${formatedDate(element.updated)} • documents:${element.filesCount} • subfolders:${element.foldersCount}',
              style: TextStyleHelper.caption(
                  color: Get.theme.colors().onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }
}

bool _isRoot(element) => element.parentId != null && element.parentId != 0;

void _onFolderPopupMenuSelected(
  value,
  Folder selectedFolder,
  BuildContext context,
  DocumentsController controller,
) async {
  switch (value) {
    case 'copyLink':
      var portalDomain = controller.portalInfoController.portalUri;

      var link =
          '${portalDomain}Products/Files/#${selectedFolder.id.toString()}';

      if (link != null) {
        await Clipboard.setData(ClipboardData(text: link));
        MessagesHandler.showSnackBar(context: context, text: tr('linkCopied'));
      }
      break;
    case 'open':
      Get.find<NavigationController>().to(FolderContentView(),
          preventDuplicates: false,
          arguments: {
            'folderName': selectedFolder.title,
            'folderId': selectedFolder.id
          });
      break;
    case 'copy':
      Get.find<NavigationController>()
          .to(DocumentsMoveOrCopyView(), preventDuplicates: false, arguments: {
        'mode': 'copyFolder',
        'target': selectedFolder.id,
        'initialFolderId': controller.currentFolder,
      });
      break;
    case 'move':
      Get.find<NavigationController>()
          .to(DocumentsMoveOrCopyView(), preventDuplicates: false, arguments: {
        'mode': 'moveFolder',
        'target': selectedFolder.id,
        'initialFolderId': controller.currentFolder,
      });

      break;
    case 'rename':
      _renameFolder(controller, selectedFolder, context);
      break;
    case 'delete':
      var success = await controller.deleteFolder(selectedFolder);

      if (success) {
        MessagesHandler.showSnackBar(
            context: context, text: tr('folderDeleted'));
        Future.delayed(const Duration(milliseconds: 500),
            () => controller.refreshContent());
      }
      break;
    default:
  }
}

void _renameFolder(
    DocumentsController controller, Folder element, BuildContext context) {
  var inputController = TextEditingController();
  inputController.text = element.title;

  Get.dialog(
    StyledAlertDialog(
      titleText: tr('renameFolder'),
      content: TextField(
        autofocus: true,
        textInputAction: TextInputAction.search,
        controller: inputController,
        decoration: InputDecoration.collapsed(
          hintText: tr('enterFolderName'),
        ),
        onSubmitted: (value) {
          controller.newSearch(value);
        },
      ),
      acceptText: tr('confirm'),
      cancelText: tr('cancel'),
      onAcceptTap: () async {
        if (inputController.text != element.title) {
          var success =
              await controller.renameFolder(element, inputController.text);
          if (success) {
            MessagesHandler.showSnackBar(
                context: context, text: tr('folderRenamed'));
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
