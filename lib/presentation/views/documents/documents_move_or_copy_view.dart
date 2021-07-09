import 'package:easy_localization/easy_localization.dart';
import 'package:projects/domain/controllers/documents/documents_move_or_copy_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_searchbar.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/styled_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';

class DocumentsMoveOrCopyView extends StatelessWidget {
  DocumentsMoveOrCopyView({Key key}) : super(key: key);

  final controller = Get.find<DocumentsMoveOrCopyController>();

  @override
  Widget build(BuildContext context) {
    final target = Get.arguments['target'];
    final int initialFolderId = Get.arguments['initialFolderId'];
    final refreshCalback = Get.arguments['refreshCalback'];
    final String mode = Get.arguments['mode'];

    controller.initialSetup();

    controller.setupOptions(target, initialFolderId);

    controller.foldersCount = 1;
    controller.refreshCalback = refreshCalback;
    controller.mode = mode;

    return MoveDocumentsScreen(
      controller: controller,
      appBar: StyledAppBar(
        title: _Title(controller: controller),
        bottom: DocsBottom(controller: controller),
        showBackButton: true,
        titleHeight: 50,
      ),
    );
  }
}

class _FolderContentView extends StatelessWidget {
  _FolderContentView({Key key}) : super(key: key);

  final controller = Get.find<DocumentsMoveOrCopyController>();

  @override
  Widget build(BuildContext context) {
    final Folder currentFolder = Get.arguments['currentFolder'];
    final target = Get.arguments['target'];
    final int initialFolderId = Get.arguments['initialFolderId'];
    final int foldersCount = Get.arguments['foldersCount'];
    final refreshCalback = Get.arguments['refreshCalback'];
    final String mode = Get.arguments['mode'];

    controller.setupFolder(
        folderName: currentFolder.title, folder: currentFolder);

    controller.setupOptions(target, initialFolderId);

    controller.foldersCount = foldersCount + 1;
    controller.refreshCalback = refreshCalback;
    controller.mode = mode;

    return MoveDocumentsScreen(
      controller: controller,
      appBar: StyledAppBar(
        title: _Title(controller: controller),
        bottom: DocsBottom(controller: controller),
        showBackButton: true,
        titleHeight: 50,
        bottomHeight: 50,
      ),
    );
  }
}

class DocumentsMoveSearchView extends StatelessWidget {
  DocumentsMoveSearchView({Key key}) : super(key: key);

  final controller = Get.find<DocumentsMoveOrCopyController>();

  @override
  Widget build(BuildContext context) {
    final Folder currentFolder = Get.arguments['currentFolder'];
    final target = Get.arguments['target'];
    final int initialFolderId = Get.arguments['initialFolderId'];
    final int foldersCount = Get.arguments['foldersCount'];
    final refreshCalback = Get.arguments['refreshCalback'];
    final String folderName = Get.arguments['folderName'];
    final String mode = Get.arguments['mode'];

    controller.setupSearchMode(folderName: folderName, folder: currentFolder);

    controller.setupOptions(target, initialFolderId);

    controller.foldersCount = foldersCount + 1;
    controller.refreshCalback = refreshCalback;
    controller.mode = mode;

    return _DocumentsScreen(
      controller: controller,
      appBar: StyledAppBar(
        title: CustomSearchBar(controller: controller),
        showBackButton: true,
        titleHeight: 50,
      ),
    );
  }
}

class _DocumentsScreen extends StatelessWidget {
  const _DocumentsScreen({
    Key key,
    @required this.controller,
    this.appBar,
  }) : super(key: key);
  final StyledAppBar appBar;
  final DocumentsMoveOrCopyController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: Obx(
        () {
          if (controller.loaded.isFalse) return const ListLoadingSkeleton();
          if (controller.loaded.isTrue && controller.nothingFound.isTrue) {
            return Center(
                child: EmptyScreen(
                    icon: AppIcon(icon: SvgIcons.not_found),
                    text: tr('notFound')));
          }
          if (controller.loaded.isTrue &&
              controller.paginationController.data.isEmpty &&
              !controller.filterController.hasFilters.value &&
              controller.searchMode.isFalse) {
            return Center(
                child: EmptyScreen(
                    icon: AppIcon(icon: SvgIcons.documents_not_created),
                    text: tr('noDocumentsCreated',
                        args: [tr('documents').toLowerCase()])));
          }
          if (controller.loaded.isTrue &&
              controller.paginationController.data.isEmpty &&
              controller.filterController.hasFilters.value &&
              controller.searchMode.isFalse) {
            return Center(
                child: EmptyScreen(
                    icon: AppIcon(icon: SvgIcons.not_found),
                    text: tr('noDocumentsMatching',
                        args: [tr('documents').toLowerCase()])));
          }
          if (controller.loaded.isTrue &&
              controller.paginationController.data.isNotEmpty) {
            return DecoratedBox(
              decoration: BoxDecoration(
                border: controller.needToShowDivider.value == true
                    ? Border(
                        top: BorderSide(
                            width: 0.5,
                            color: Theme.of(context)
                                .customColors()
                                .onBackground
                                .withOpacity(0.2)),
                      )
                    : null,
              ),
              position: DecorationPosition.foreground,
              child: PaginationListView(
                paginationController: controller.paginationController,
                child: ListView.separated(
                  itemCount: controller.paginationController.data.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var element = controller.paginationController.data[index];
                    return _MoveFolderCell(
                      element: element,
                      controller: controller,
                    );
                  },
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key key, @required this.controller}) : super(key: key);

  final DocumentsMoveOrCopyController controller;
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
                  var target;
                  target = controller.target;

                  Get.to(DocumentsMoveSearchView(),
                      preventDuplicates: false,
                      arguments: {
                        'mode': controller.mode,
                        'folderName': controller.screenName.value,
                        'target': target,
                        'currentFolder': controller.currentFolder,
                        'initialFolderId': controller.initialFolderId,
                        'foldersCount': controller.foldersCount,
                        'refreshCalback': controller.refreshCalback,
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

class _MoveFolderCell extends StatelessWidget {
  const _MoveFolderCell({
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
        Get.to(_FolderContentView(), preventDuplicates: false, arguments: {
          'mode': controller.mode,
          'target': target,
          'currentFolder': element,
          'initialFolderId': controller.initialFolderId,
          'foldersCount': controller.foldersCount,
          'refreshCalback': controller.refreshCalback,
        });
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
          ],
        ),
      ),
    );
  }
}

class MoveDocumentsScreen extends StatelessWidget {
  const MoveDocumentsScreen({
    Key key,
    @required this.controller,
    this.appBar,
  }) : super(key: key);
  final StyledAppBar appBar;
  final DocumentsMoveOrCopyController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (controller.loaded.isFalse) const ListLoadingSkeleton(),
            if (controller.loaded.isTrue && controller.nothingFound.isTrue)
              const Expanded(
                child: Center(
                  child: NothingFound(),
                ),
              ),
            if (controller.loaded.isTrue &&
                controller.paginationController.data.isEmpty &&
                !controller.filterController.hasFilters.value &&
                controller.searchMode.isFalse)
              Expanded(
                child: Center(
                  child: EmptyScreen(
                      icon: AppIcon(icon: SvgIcons.documents_not_created),
                      text: tr('noDocumentsCreated',
                          args: [tr('documents').toLowerCase()])),
                ),
              ),
            if (controller.loaded.isTrue &&
                controller.paginationController.data.isEmpty &&
                controller.filterController.hasFilters.value &&
                controller.searchMode.isFalse)
              Expanded(
                child: Center(
                  child: EmptyScreen(
                      icon: AppIcon(icon: SvgIcons.not_found),
                      text: tr('noDocumentsMatching',
                          args: [tr('documents').toLowerCase()])),
                ),
              ),
            if (controller.loaded.isTrue &&
                controller.paginationController.data.isNotEmpty)
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: controller.needToShowDivider.value == true
                        ? Border(
                            top: BorderSide(
                                width: 0.5,
                                color: Theme.of(context)
                                    .customColors()
                                    .onBackground
                                    .withOpacity(0.2)),
                          )
                        : null,
                  ),
                  position: DecorationPosition.foreground,
                  child: PaginationListView(
                    paginationController: controller.paginationController,
                    child: ListView.separated(
                      itemCount: controller.paginationController.data.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        var element =
                            controller.paginationController.data[index];
                        return element is Folder
                            ? _MoveFolderCell(
                                element: element,
                                controller: controller,
                              )
                            : const SizedBox();
                      },
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () => _cancel(controller),
                  child: Text(tr('cancel').toUpperCase(),
                      style: TextStyleHelper.button()),
                ),
                if (controller.mode == 'moveFolder' &&
                    !_isRoot(controller.currentFolder))
                  TextButton(
                    onPressed: () => _moveFolder(controller, context),
                    child: Text(tr('moveFolderHere').toUpperCase(),
                        style: TextStyleHelper.button()),
                  ),
                if (controller.mode == 'copyFolder' &&
                    !_isRoot(controller.currentFolder))
                  TextButton(
                    onPressed: () => _copyFolder(controller, context),
                    child: Text(tr('copyFolderHere').toUpperCase(),
                        style: TextStyleHelper.button()),
                  ),
                if (controller.mode == 'moveFile' &&
                    !_isRoot(controller.currentFolder))
                  TextButton(
                    onPressed: () => _moveFile(controller, context),
                    child: Text(tr('moveFileHere').toUpperCase(),
                        style: TextStyleHelper.button()),
                  ),
                if (controller.mode == 'copyFile' &&
                    !_isRoot(controller.currentFolder))
                  TextButton(
                    onPressed: () => _copyFile(controller, context),
                    child: Text(tr('copyFileHere').toUpperCase(),
                        style: TextStyleHelper.button()),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future _moveFolder(
  DocumentsMoveOrCopyController controller,
  BuildContext context,
) async {
  var success = await controller.moveFolder();

  if (success) {
    Get.close(controller.foldersCount);
    if (controller.refreshCalback != null) controller.refreshCalback();

    ScaffoldMessenger.of(context).showSnackBar(
        styledSnackBar(context: context, text: tr('folderMoved')));
  }
}

Future _copyFolder(
  DocumentsMoveOrCopyController controller,
  BuildContext context,
) async {
  var success = await controller.copyFolder();

  if (success) {
    Get.close(controller.foldersCount);
    if (controller.refreshCalback != null) controller.refreshCalback();

    ScaffoldMessenger.of(context).showSnackBar(
        styledSnackBar(context: context, text: tr('folderCopied')));
  }
}

Future _moveFile(
  DocumentsMoveOrCopyController controller,
  BuildContext context,
) async {
  var success = await controller.moveFile();

  if (success) {
    Get.close(controller.foldersCount);
    if (controller.refreshCalback != null) controller.refreshCalback();

    ScaffoldMessenger.of(context)
        .showSnackBar(styledSnackBar(context: context, text: tr('fileMoved')));
  }
}

Future _copyFile(
  DocumentsMoveOrCopyController controller,
  BuildContext context,
) async {
  var success = await controller.copyFile();

  if (success) {
    Get.close(controller.foldersCount);
    if (controller.refreshCalback != null) controller.refreshCalback();

    ScaffoldMessenger.of(context)
        .showSnackBar(styledSnackBar(context: context, text: tr('fileCopied')));
  }
}

Future _cancel(DocumentsMoveOrCopyController controller) async {
  Get.close(controller.foldersCount);
  if (controller.refreshCalback != null) controller.refreshCalback();
}

bool _isRoot(element) {
  return element == null || (element.parentId != null && element.parentId != 0);
}
