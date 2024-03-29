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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/domain/controllers/documents/documents_move_or_copy_controller.dart';
import 'package:projects/domain/controllers/documents/file_cell_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/search_button.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/documents/documents_shared.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';
import 'package:projects/presentation/views/documents/folder_cell.dart';

class DocumentsMoveOrCopyView extends StatelessWidget {
  DocumentsMoveOrCopyView({Key? key}) : super(key: key);

  final controller = Get.find<DocumentsMoveOrCopyController>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments ?? Get.arguments;

    final target = args['target'] as int;
    final initialFolderId = args['initialFolderId'] as int?;
    final mode = args['mode'] as MoveOrCopyMode;

    final currentFolder = args['currentFolder'] as Folder?;
    final nestingCounter = args['nestingCounter'] as int?;

    if (currentFolder == null)
      controller.initialSetup();
    else
      controller.setupFolder(
        folderName: currentFolder.title!,
        folder: currentFolder,
      );

    controller.setupOptions(target, initialFolderId);

    if (nestingCounter != null) controller.nestingCounter = nestingCounter + 1;
    controller.mode = mode;

    return MoveDocumentsScreen(
      controller: controller,
      appBar: StyledAppBar(
        centerTitle: GetPlatform.isIOS,
        title: Obx(() => Text(
              controller.documentsScreenName.value,
              style: TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface),
            )),
        actions: [
          SearchButton(controller: controller),
          DocumentsFilterButton(controller: controller),
          DocumentsMoreButton(controller: controller),
        ],
      ),
    );
  }
}

class DocumentsMoveSearchView extends StatelessWidget {
  DocumentsMoveSearchView({Key? key}) : super(key: key);

  final controller = Get.find<DocumentsMoveOrCopyController>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments ?? Get.arguments;

    final target = args['target'] as int;
    final initialFolderId = args['initialFolderId'] as int?;
    final mode = args['mode'] as MoveOrCopyMode;

    final currentFolder = args['currentFolder'] as Folder?;
    final nestingCounter = args['nestingCounter'] as int;

    if (currentFolder == null)
      controller.initialSetup();
    else
      controller.setupFolder(
        folderName: currentFolder.title!,
        folder: currentFolder,
      );

    controller.setupOptions(target, initialFolderId);

    controller.nestingCounter = nestingCounter + 1;
    controller.mode = mode;

    return Scaffold(
      appBar: StyledAppBar(
        title: SearchField(
          controller: controller.searchInputController,
          margin: const EdgeInsets.only(right: 16, top: 4),
          autofocus: true,
          hintText: tr('enterQuery'),
          onSubmitted: controller.newSearch,
          onChanged: controller.newSearch,
          onClearPressed: controller.clearSearch,
        ),
      ),
      body: MoveOrCopyFolderContent(controller: controller),
    );
  }
}

class MoveDocumentsScreen extends StatelessWidget {
  const MoveDocumentsScreen({
    Key? key,
    required this.controller,
    this.appBar,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final DocumentsMoveOrCopyController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: Stack(
        children: [
          MoveOrCopyFolderContent(controller: controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Theme.of(context).colors().surface,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PlatformTextButton(
                      onPressed: controller.cancelCopying,
                      child: Text(tr('cancel').toUpperCase(), style: TextStyleHelper.button()),
                    ),
                    if (controller.currentFolderID != null && controller.currentFolder != null)
                      PlatformTextButton(
                        onPressed: controller.processMoveOrCopy,
                        child: Text(() {
                          switch (controller.mode) {
                            case MoveOrCopyMode.CopyDocument:
                              return tr('copyFileHere').toUpperCase();
                            case MoveOrCopyMode.CopyFolder:
                              return tr('copyFolderHere').toUpperCase();
                            case MoveOrCopyMode.MoveDocument:
                              return tr('moveFileHere').toUpperCase();
                            case MoveOrCopyMode.MoveFolder:
                              return tr('moveFolderHere').toUpperCase();
                          }
                        }(), style: TextStyleHelper.button()),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MoveOrCopyFolderContent extends StatelessWidget {
  const MoveOrCopyFolderContent({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final DocumentsMoveOrCopyController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (!controller.loaded.value) return const ListLoadingSkeleton();

        final scrollController = ScrollController();
        return PaginationListView(
            scrollController: scrollController,
            paginationController: controller.paginationController,
            child: () {
              if (controller.loaded.value && controller.nothingFound.value) {
                return Center(child: EmptyScreen(icon: SvgIcons.not_found, text: tr('notFound')));
              }
              if (controller.loaded.value &&
                  controller.paginationController.data.isEmpty &&
                  !controller.filterController.hasFilters.value &&
                  !controller.searchMode.value) {
                return Center(
                    child: EmptyScreen(
                        icon: SvgIcons.documents_not_created, text: tr('noDocumentsCreated')));
              }
              if (controller.loaded.value &&
                  controller.paginationController.data.isEmpty &&
                  controller.filterController.hasFilters.value &&
                  controller.searchMode.value) {
                return Center(
                    child: EmptyScreen(icon: SvgIcons.not_found, text: tr('noDocumentsMatching')));
              }
              if (controller.loaded.value && controller.paginationController.data.isNotEmpty)
                return ListView.separated(
                  controller: scrollController,
                  itemCount: controller.paginationController.data.length,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                  itemBuilder: (BuildContext context, int index) {
                    final element = controller.paginationController.data[index];
                    return element is Folder
                        ? MoveFolderCell(
                            element: element,
                            controller: controller,
                          )
                        : _FileCell(
                            cellController: FileCellController(file: element as PortalFile),
                          );
                  },
                );

              return const SizedBox();
            }());
      },
    );
  }
}

class _FileCell extends StatelessWidget {
  const _FileCell({Key? key, required this.cellController}) : super(key: key);

  final FileCellController cellController;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        color: Theme.of(context).colors().onSurface.withOpacity(0.6))),
              ],
            ),
          ),
          const SizedBox(width: 16)
        ],
      ),
    );
  }
}
