import 'dart:math' as math;
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/domain/controllers/documents/discussions_documents_controller.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_searchbar.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_snackbar.dart';
import 'package:projects/presentation/views/documents/documents_move_or_copy_view.dart';
import 'package:projects/presentation/views/documents/documents_sort_options.dart';

class PortalDocumentsView extends StatelessWidget {
  const PortalDocumentsView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>();
    controller.initialSetup();

    return DocumentsScreen(
      controller: controller,
      appBar: StyledAppBar(
        title: DocsTitle(controller: controller),
        bottom: DocsBottom(controller: controller),
        showBackButton: false,
        titleHeight: 50,
        bottomHeight: 50,
      ),
    );
  }
}

class FolderContentView extends StatelessWidget {
  FolderContentView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>();
    final String folderName = Get.arguments['folderName'];
    final int folderId = Get.arguments['folderId'];
    controller.setupFolder(folderName: folderName, folderId: folderId);

    return DocumentsScreen(
      controller: controller,
      appBar: StyledAppBar(
        title: DocsTitle(controller: controller),
        bottom: DocsBottom(controller: controller),
        showBackButton: true,
        titleHeight: 50,
        bottomHeight: 50,
      ),
    );
  }
}

class DocumentsSearchView extends StatelessWidget {
  DocumentsSearchView({Key key}) : super(key: key);

  final documentsController = Get.find<DocumentsController>();

  @override
  Widget build(BuildContext context) {
    final String folderName = Get.arguments['folderName'];
    final int folderId = Get.arguments['folderId'];

    documentsController.entityType = Get.arguments['entityType'];
    documentsController.setupSearchMode(
        folderName: folderName, folderId: folderId);

    return DocumentsScreen(
      controller: documentsController,
      appBar: StyledAppBar(
        title: CustomSearchBar(controller: documentsController),
        showBackButton: true,
        titleHeight: 50,
      ),
    );
  }
}

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({
    Key key,
    @required this.controller,
    this.appBar,
  }) : super(key: key);
  final StyledAppBar appBar;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (controller.needToShowDevider.value == true)
              const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
            if (controller.loaded.value == false) const ListLoadingSkeleton(),
            if (controller.loaded.value == true &&
                controller.nothingFound.value == true)
              Expanded(
                child: Center(
                  child: EmptyScreen(
                      icon: AppIcon(icon: SvgIcons.not_found),
                      text: tr('notFound')),
                ),
              ),
            if (controller.loaded.value == true &&
                controller.paginationController.data.isEmpty &&
                !controller.filterController.hasFilters.value &&
                controller.searchMode.value == false)
              Expanded(
                child: Center(
                  child: EmptyScreen(
                      icon: AppIcon(icon: SvgIcons.documents_not_created),
                      text: tr('noEntityCreated',
                          args: [tr('documents').toLowerCase()])),
                ),
              ),
            if (controller.loaded.value == true &&
                controller.paginationController.data.isEmpty &&
                controller.filterController.hasFilters.value &&
                controller.searchMode.value == false)
              Expanded(
                child: Center(
                  child: EmptyScreen(
                      icon: AppIcon(icon: SvgIcons.not_found),
                      text: tr('noEntityMatching',
                          args: [tr('documents').toLowerCase()])),
                ),
              ),
            if (controller.loaded.value == true &&
                controller.paginationController.data.isNotEmpty)
              Expanded(
                child: PaginationListView(
                  paginationController: controller.paginationController,
                  child: ListView.separated(
                    controller: controller.scrollController,
                    itemCount: controller.paginationController.data.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      var element = controller.paginationController.data[index];
                      return element is Folder
                          ? FolderCell(
                              element: element,
                              controller: controller,
                            )
                          : FileCell(
                              element: element,
                              index: index,
                              controller: controller,
                            );
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

class DocsTitle extends StatelessWidget {
  const DocsTitle({Key key, @required this.controller}) : super(key: key);
  final controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Obx(
              () => Text(
                controller.screenName.value,
                style: TextStyleHelper.headerStyle,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkResponse(
                onTap: () {
                  Get.to(DocumentsSearchView(),
                      preventDuplicates: false,
                      arguments: {
                        'folderName': controller.screenName.value,
                        'folderId': controller.currentFolder,
                        'documentsController': controller,
                      });
                },
                child: AppIcon(
                  width: 24,
                  height: 24,
                  icon: SvgIcons.search,
                  color: Theme.of(context).customColors().primary,
                ),
              ),
              const SizedBox(width: 24),
              InkResponse(
                onTap: () async => Get.toNamed('DocumentsFilterScreen',
                    preventDuplicates: false,
                    arguments: {
                      'filterController': controller.filterController
                    }),
                child: FiltersButton(controler: controller),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DocsBottom extends StatelessWidget {
  DocsBottom({Key key, this.controller}) : super(key: key);
  final controller;
  @override
  Widget build(BuildContext context) {
    var sortButton = Container(
      padding: const EdgeInsets.only(right: 4),
      child: InkResponse(
        onTap: () {
          Get.bottomSheet(
            SortView(sortOptions: DocumentsSortOption(controller: controller)),
            isScrollControlled: true,
          );
        },
        child: Row(
          children: <Widget>[
            Obx(
              () => Text(
                controller.sortController.currentSortTitle.value,
                style: TextStyleHelper.projectsSorting,
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => (controller.sortController.currentSortOrder == 'ascending')
                  ? AppIcon(
                      icon: SvgIcons.sorting_4_ascend,
                      width: 20,
                      height: 20,
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(math.pi),
                      child: AppIcon(
                        icon: SvgIcons.sorting_4_ascend,
                        width: 20,
                        height: 20,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              sortButton,
              Container(
                child: Row(
                  children: <Widget>[
                    Obx(
                      () => Text(
                        tr('total', args: [
                          controller.paginationController.total.value.toString()
                        ]),
                        style: TextStyleHelper.body2(
                          color: Theme.of(context)
                              .customColors()
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color(0xffD8D8D8),
                  ),
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Obx(() {
                    if (controller.paginationController.data[index].fileType ==
                        7)
                      return AppIcon(width: 20, height: 20, icon: SvgIcons.doc);
                    if (controller.paginationController.data[index].fileType ==
                        5)
                      return AppIcon(
                          width: 20, height: 20, icon: SvgIcons.table);
                    if (controller.paginationController.data[index].fileType ==
                        4)
                      return AppIcon(
                          width: 20, height: 20, icon: SvgIcons.image);
                    if (controller.paginationController.data[index].fileType ==
                        6)
                      return AppIcon(
                          width: 20, height: 20, icon: SvgIcons.presentation);

                    return AppIcon(
                        width: 20,
                        height: 20,
                        icon: SvgIcons.documents,
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6));
                  }),
                ),
              ),
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
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6))),
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
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.5)),
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
                            color: Theme.of(context).customColors().error),
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
        Get.to(FolderContentView(),
            preventDuplicates: false,
            arguments: {'folderName': element.title, 'folderId': element.id});
      },
      child: Container(
        height: 72,
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xffD8D8D8),
                    ),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppIcon(
                      width: 20,
                      height: 20,
                      icon: SvgIcons.folder,
                    ),
                  ),
                ),
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
                      tr('documentsCaption', args: [
                        formatedDate(element.updated),
                        element.filesCount.toString(),
                        element.foldersCount.toString()
                      ]),
                      // '${formatedDate(element.updated)} • documents:${element.filesCount} • subfolders:${element.foldersCount}',
                      style: TextStyleHelper.caption(
                          color: Theme.of(context)
                              .customColors()
                              .onSurface
                              .withOpacity(0.6))),
                ],
              ),
            ),
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
                      color: Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.5)),
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
                      // const PopupMenuItem(
                      //   value: 'download',
                      //   child: Text('Download'),
                      // ),
                      if (!(controller is DiscussionsDocumentsController))
                        PopupMenuItem(
                          value: 'copy',
                          child: Text(tr('copy')),
                        ),
                      if (_isRoot(element) &&
                          !(controller is DiscussionsDocumentsController))
                        PopupMenuItem(
                          value: 'move',
                          child: Text(tr('move')),
                        ),
                      if (_isRoot(element))
                        PopupMenuItem(
                          value: 'rename',
                          child: Text(tr('rename')),
                        ),
                      if (_isRoot(element))
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            tr('delete'),
                            style: TextStyleHelper.subtitle1(
                                color: Theme.of(context).customColors().error),
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
        ScaffoldMessenger.of(context).showSnackBar(
            styledSnackBar(context: context, text: tr('linkCopied')));
      }
      break;
    case 'open':
      await Get.to(FolderContentView(), preventDuplicates: false, arguments: {
        'folderName': selectedFolder.title,
        'folderId': selectedFolder.id
      });
      break;
    case 'download':
      controller.downloadFolder();
      break;
    case 'copy':
      await Get.to(DocumentsMoveOrCopyView(),
          preventDuplicates: false,
          arguments: {
            'mode': 'copyFolder',
            'target': selectedFolder.id,
            'initialFolderId': controller.currentFolder,
            'refreshCalback': controller.refreshContent
          });
      break;
    case 'move':
      await Get.to(DocumentsMoveOrCopyView(),
          preventDuplicates: false,
          arguments: {
            'mode': 'moveFolder',
            'target': selectedFolder.id,
            'initialFolderId': controller.currentFolder,
            'refreshCalback': controller.refreshContent
          });

      break;
    case 'rename':
      _renameFolder(controller, selectedFolder, context);
      break;
    case 'delete':
      var success = await controller.deleteFolder(selectedFolder);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            styledSnackBar(context: context, text: tr('folderDeleted')));
        Future.delayed(const Duration(milliseconds: 500),
            () => controller.refreshContent());
      }
      break;
    default:
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
        ScaffoldMessenger.of(context).showSnackBar(
            styledSnackBar(context: context, text: tr('linkCopied')));
      }
      break;
    case 'open':
      await controller.openFile(selectedFile);
      break;
    case 'download':
      await controller.downloadFile(selectedFile.viewUrl);
      break;
    case 'copy':
      await Get.to(DocumentsMoveOrCopyView(),
          preventDuplicates: false,
          arguments: {
            'mode': 'copyFile',
            'target': selectedFile.id,
            'initialFolderId': controller.currentFolder,
            'refreshCalback': controller.refreshContent
          });
      break;
    case 'move':
      await Get.to(DocumentsMoveOrCopyView(),
          preventDuplicates: false,
          arguments: {
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
        ScaffoldMessenger.of(context).showSnackBar(
            styledSnackBar(context: context, text: tr('fileDeleted')));
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
            ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
              context: context,
              text: tr('folderRenamed'),
            ));
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
            ScaffoldMessenger.of(context).showSnackBar(
                styledSnackBar(context: context, text: tr('fileRenamed')));
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
