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
import 'package:projects/domain/controllers/documents/documents_move_or_copy_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_searchbar.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';
import 'package:projects/presentation/views/documents/filter/documents_filter_screen.dart';
import 'package:projects/presentation/views/documents/folder_cell.dart';

class DocumentsMoveOrCopyView extends StatelessWidget {
  DocumentsMoveOrCopyView({Key? key}) : super(key: key);

  final controller = Get.find<DocumentsMoveOrCopyController>();

  @override
  Widget build(BuildContext context) {
    final target = Get.arguments['target'] as int?;
    final initialFolderId = Get.arguments['initialFolderId'] as int?;
    final mode = Get.arguments['mode'] as String?;

    controller.initialSetup();

    controller.setupOptions(target, initialFolderId);

    controller.foldersCount = 1;
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
          builder: (_, double value, __) => StyledAppBar(
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
  MoveFolderContentView({Key? key}) : super(key: key);

  final controller = Get.find<DocumentsMoveOrCopyController>();

  @override
  Widget build(BuildContext context) {
    final currentFolder = Get.arguments['currentFolder'] as Folder;
    final target = Get.arguments['target'] as int?;
    final initialFolderId = Get.arguments['initialFolderId'] as int?;
    final foldersCount = Get.arguments['foldersCount'] as int;
    final mode = Get.arguments['mode'] as String?;

    controller.setupFolder(
        folderName: currentFolder.title!, folder: currentFolder);

    controller.setupOptions(target, initialFolderId);

    controller.foldersCount = foldersCount + 1;
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
          builder: (_, double value, __) => StyledAppBar(
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
  DocumentsMoveSearchView({Key? key}) : super(key: key);

  final controller = Get.find<DocumentsMoveOrCopyController>();

  @override
  Widget build(BuildContext context) {
    final currentFolder = Get.arguments['currentFolder'] as Folder?;
    final target = Get.arguments['target'] as int?;
    final initialFolderId = Get.arguments['initialFolderId'] as int?;
    final foldersCount = Get.arguments['foldersCount'] as int;
    final folderName = Get.arguments['folderName'] as String?;
    final mode = Get.arguments['mode'] as String?;

    controller.setupSearchMode(folderName: folderName, folder: currentFolder);

    controller.setupOptions(target, initialFolderId);

    controller.foldersCount = foldersCount + 1;
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
          builder: (_, dynamic value, __) => StyledAppBar(
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
    Key? key,
    required this.controller,
    required this.scrollController,
    this.appBar,
  }) : super(key: key);
  final PreferredSizeWidget? appBar;
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
                    text: tr('noDocumentsCreated')));
          }
          if (controller.loaded.value == true &&
              controller.paginationController.data.isEmpty &&
              controller.filterController.hasFilters.value &&
              controller.searchMode.value == false) {
            return Center(
                child: EmptyScreen(
                    icon: SvgIcons.not_found, text: tr('noDocumentsMatching')));
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
                    element: element as Folder,
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
  const _Title({Key? key, required this.controller}) : super(key: key);

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
                style: TextStyleHelper.headerStyle(
                    color: Get.theme.colors().onSurface),
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
    Key? key,
    required this.controller,
    required this.scrollController,
    this.appBar,
  }) : super(key: key);
  final PreferredSizeWidget? appBar;
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
                      text: tr('noDocumentsCreated')),
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
                      if (controller.target == element.id)
                        return const SizedBox();
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
                  onPressed: () => Get.close(controller.foldersCount),
                  child: Text(tr('cancel').toUpperCase(),
                      style: TextStyleHelper.button()),
                ),
                if (controller.mode == 'moveFolder' &&
                    controller.currentFolder != null)
                  TextButton(
                    onPressed: controller.moveFolder,
                    child: Text(tr('moveFolderHere').toUpperCase(),
                        style: TextStyleHelper.button()),
                  ),
                if (controller.mode == 'copyFolder' &&
                    controller.currentFolder != null)
                  TextButton(
                    onPressed: controller.copyFolder,
                    child: Text(tr('copyFolderHere').toUpperCase(),
                        style: TextStyleHelper.button()),
                  ),
                if (controller.mode == 'moveFile' &&
                    controller.currentFolder != null)
                  TextButton(
                    onPressed: controller.moveFile,
                    child: Text(tr('moveFileHere').toUpperCase(),
                        style: TextStyleHelper.button()),
                  ),
                if (controller.mode == 'copyFile' &&
                    controller.currentFolder != null)
                  TextButton(
                    onPressed: controller.copyFile,
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
