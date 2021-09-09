import 'package:easy_localization/easy_localization.dart';
import 'package:projects/domain/controllers/documents/documents_move_or_copy_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_searchbar.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';
import 'package:projects/presentation/views/documents/filter/documents_filter.dart';
import 'package:projects/presentation/views/documents/folder_cell.dart';

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

    var scrollController = ScrollController();
    var elevation = ValueNotifier<double>(0);

    scrollController.addListener(
        () => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return MoveDocumentsScreen(
      controller: controller,
      scrollController: scrollController,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 101),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, value, __) => StyledAppBar(
            title: _Title(controller: controller),
            bottom: DocsBottom(controller: controller),
            showBackButton: true,
            titleHeight: 50,
            elevation: value,
          ),
        ),
      ),
    );
  }
}

class MoveFolderContentView extends StatelessWidget {
  MoveFolderContentView({Key key}) : super(key: key);

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

    var scrollController = ScrollController();
    var elevation = ValueNotifier<double>(0);

    scrollController.addListener(
        () => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return MoveDocumentsScreen(
      controller: controller,
      scrollController: scrollController,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 101),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, value, __) => StyledAppBar(
            title: _Title(controller: controller),
            bottom: DocsBottom(controller: controller),
            showBackButton: true,
            titleHeight: 50,
            bottomHeight: 50,
            elevation: value,
          ),
        ),
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

    var scrollController = ScrollController();
    var elevation = ValueNotifier<double>(0);

    scrollController.addListener(
        () => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return _DocumentsScreen(
      controller: controller,
      scrollController: scrollController,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 101),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, value, __) => StyledAppBar(
            title: CustomSearchBar(controller: controller),
            showBackButton: true,
            titleHeight: 50,
          ),
        ),
      ),
    );
  }
}

class _DocumentsScreen extends StatelessWidget {
  const _DocumentsScreen({
    Key key,
    @required this.controller,
    @required this.scrollController,
    this.appBar,
  }) : super(key: key);
  final PreferredSizeWidget appBar;
  final DocumentsMoveOrCopyController controller;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      appBar: appBar,
      body: Obx(
        () {
          if (controller.loaded.value == false)
            return const ListLoadingSkeleton();
          if (controller.loaded.value == true &&
              controller.nothingFound.value == true) {
            return Center(
                child: EmptyScreen(
                    icon: SvgIcons.not_found, text: tr('notFound')));
          }
          if (controller.loaded.value == true &&
              controller.paginationController.data.isEmpty &&
              !controller.filterController.hasFilters.value &&
              controller.searchMode.value == false) {
            return Center(
                child: EmptyScreen(
                    icon: SvgIcons.documents_not_created,
                    text: tr('noDocumentsCreated',
                        args: [tr('documents').toLowerCase()])));
          }
          if (controller.loaded.value == true &&
              controller.paginationController.data.isEmpty &&
              controller.filterController.hasFilters.value &&
              controller.searchMode.value == false) {
            return Center(
                child: EmptyScreen(
                    icon: SvgIcons.not_found,
                    text: tr('noDocumentsMatching',
                        args: [tr('documents').toLowerCase()])));
          }
          if (controller.loaded.value == true &&
              controller.paginationController.data.isNotEmpty) {
            return PaginationListView(
              paginationController: controller.paginationController,
              child: ListView.separated(
                itemCount: controller.paginationController.data.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (BuildContext context, int index) {
                  var element = controller.paginationController.data[index];
                  return MoveFolderCell(
                    element: element,
                    controller: controller,
                  );
                },
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

                  Get.find<NavigationController>().to(DocumentsMoveSearchView(),
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
                  color: Get.theme.colors().primary,
                ),
              ),
              const SizedBox(width: 24),
              InkResponse(
                onTap: () async => Get.find<NavigationController>().toScreen(
                    const DocumentsFilterScreen(),
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

class MoveDocumentsScreen extends StatelessWidget {
  const MoveDocumentsScreen({
    Key key,
    @required this.controller,
    @required this.scrollController,
    this.appBar,
  }) : super(key: key);
  final PreferredSizeWidget appBar;
  final DocumentsMoveOrCopyController controller;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      appBar: appBar,
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (controller.loaded.value == false) const ListLoadingSkeleton(),
            if (controller.loaded.value == true &&
                controller.nothingFound.value == true)
              const Expanded(
                child: Center(
                  child: NothingFound(),
                ),
              ),
            if (controller.loaded.value == true &&
                controller.paginationController.data.isEmpty &&
                !controller.filterController.hasFilters.value &&
                controller.searchMode.value == false)
              Expanded(
                child: Center(
                  child: EmptyScreen(
                      icon: SvgIcons.documents_not_created,
                      text: tr('noDocumentsCreated',
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
                      icon: SvgIcons.not_found,
                      text: tr('noDocumentsMatching',
                          args: [tr('documents').toLowerCase()])),
                ),
              ),
            if (controller.loaded.value == true &&
                controller.paginationController.data.isNotEmpty)
              Expanded(
                child: PaginationListView(
                  paginationController: controller.paginationController,
                  child: ListView.separated(
                    itemCount: controller.paginationController.data.length,
                    controller: scrollController,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      var element = controller.paginationController.data[index];
                      return element is Folder
                          ? MoveFolderCell(
                              element: element,
                              controller: controller,
                            )
                          : const SizedBox();
                    },
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
