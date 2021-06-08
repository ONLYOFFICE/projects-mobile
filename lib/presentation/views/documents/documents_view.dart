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

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_snackbar.dart';
import 'package:projects/presentation/views/documents/filter/documents_filter.dart';
import 'package:projects/presentation/views/documents/move_document_view.dart';

class PortalDocumentsView extends StatelessWidget {
  const PortalDocumentsView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>();
    controller.initialSetup();

    return DocumentsScreen(
      controller: controller,
      appBar: StyledAppBar(
        title: Title(controller: controller),
        bottom: Bottom(controller: controller),
        showBackButton: false,
        titleHeight: 50,
        bottomHeight: 50,
      ),
    );
  }
}

class FolderContentView extends StatelessWidget {
  FolderContentView({Key key}) : super(key: key);

  final controller = Get.find<DocumentsController>();

  @override
  Widget build(BuildContext context) {
    final String folderName = Get.arguments['folderName'];
    final int folderId = Get.arguments['folderId'];
    controller.setupFolder(folderName: folderName, folderId: folderId);

    return DocumentsScreen(
      controller: controller,
      appBar: StyledAppBar(
        title: Title(controller: controller),
        bottom: Bottom(controller: controller),
        showBackButton: true,
        titleHeight: 50,
        bottomHeight: 50,
      ),
    );
  }
}

class DocumentsSearchView extends StatelessWidget {
  DocumentsSearchView({Key key}) : super(key: key);

  final controller = Get.find<DocumentsController>();

  @override
  Widget build(BuildContext context) {
    final String folderName = Get.arguments['folderName'];
    final int folderId = Get.arguments['folderId'];
    controller.setupSearchMode(folderName: folderName, folderId: folderId);

    return DocumentsScreen(
      controller: controller,
      appBar: StyledAppBar(
        title: SearchHeader(controller: controller),
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
  final DocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (controller.nothingFound.isTrue) const NothingFound(),
            if (controller.loaded.isFalse) const ListLoadingSkeleton(),
            if (controller.loaded.isTrue)
              Expanded(
                child: PaginationListView(
                  paginationController: controller.paginationController,
                  child: ListView.separated(
                    itemCount: controller.paginationController.data.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      var element = controller.paginationController.data[index];
                      return element is Folder
                          ? FolderContent(
                              element: element,
                              controller: controller,
                            )
                          : FileContent(
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

class SearchHeader extends StatelessWidget {
  const SearchHeader({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final DocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        child: Material(
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  controller: controller.searchInputController,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Enter your query'),
                  onSubmitted: (value) {
                    controller.newSearch(value);
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  controller.clearSearch();
                },
                child: const Icon(Icons.close, color: Colors.blue),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key key, @required this.controller}) : super(key: key);

  final DocumentsController controller;
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
              InkWell(
                onTap: () {
                  Get.to(DocumentsSearchView(),
                      preventDuplicates: false,
                      arguments: {
                        'folderName': controller.screenName.value,
                        'folderId': controller.folderId
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
              InkWell(
                onTap: () async => Get.toNamed('DocumentsFilterScreen',
                    preventDuplicates: false,
                    arguments: {
                      'filterController': controller.filterController
                    }),
                child: FiltersButton(controler: controller),
              ),
              const SizedBox(width: 24),
              InkWell(
                onTap: () {},
                child: AppIcon(
                  width: 24,
                  height: 24,
                  icon: SvgIcons.tasklist,
                  color: Theme.of(context).customColors().primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Bottom extends StatelessWidget {
  Bottom({Key key, this.controller}) : super(key: key);
  final DocumentsController controller;
  @override
  Widget build(BuildContext context) {
    var options = Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        SortTile(
          sortParameter: 'dateandtime',
          sortController: controller.sortController,
        ),
        SortTile(
          sortParameter: 'create_on',
          sortController: controller.sortController,
        ),
        SortTile(
          sortParameter: 'title',
          sortController: controller.sortController,
        ),
        SortTile(
          sortParameter: 'type',
          sortController: controller.sortController,
        ),
        SortTile(
          sortParameter: 'size',
          sortController: controller.sortController,
        ),
        SortTile(
          sortParameter: 'author',
          sortController: controller.sortController,
        ),
        const SizedBox(height: 20),
      ],
    );

    var sortButton = Container(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: () {
          Get.bottomSheet(
            SortView(sortOptions: options),
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
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
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
                        'Total ${controller.paginationController.total.value}',
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
        const Divider(
          height: 1,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        ),
      ],
    );
  }
}

class FileContent extends StatelessWidget {
  final int index;

  final PortalFile element;
  final DocumentsController controller;

  const FileContent({
    Key key,
    @required this.element,
    @required this.index,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // SizedBox(
          //   width: 72,
          //   child: Center(
          //     child: Text(paginationController.data[index].fileType.toString()),
          //   ),
          // ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(element.title),
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
                    // const PopupMenuItem(
                    //   value: 'open',
                    //   child: Text('Open'),
                    // ),
                    const PopupMenuItem(
                      value: 'copyLink',
                      child: Text('Copy link'),
                    ),
                    // const PopupMenuItem(
                    //   value: 'download',
                    //   child: Text('Download'),
                    // ),
                    // const PopupMenuItem(
                    //   value: 'copy',
                    //   child: Text('Copy'),
                    // ),
                    //   const PopupMenuItem(
                    //     value: 'move',
                    //     child: Text('Move'),
                    //   ),
                    const PopupMenuItem(
                      value: 'rename',
                      child: Text('Rename'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
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

class FolderContent extends StatelessWidget {
  const FolderContent({
    Key key,
    @required this.element,
    @required this.controller,
  }) : super(key: key);

  final Folder element;
  final DocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(FolderContentView(),
            preventDuplicates: false,
            arguments: {'folderName': element.title, 'folderId': element.id});
      },
      child: Container(
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
                children: [
                  Text(element.title),
                  Text(
                      '${formatedDate(element.updated)} • documents:${element.filesCount} • subfolders:${element.foldersCount}',
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
                      value, element, context, controller),
                  icon: Icon(Icons.more_vert,
                      color: Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.5)),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'open',
                        child: Text('Open'),
                      ),
                      const PopupMenuItem(
                        value: 'copyLink',
                        child: Text('Copy link'),
                      ),
                      // const PopupMenuItem(
                      //   value: 'download',
                      //   child: Text('Download'),
                      // ),
                      // const PopupMenuItem(
                      //   value: 'copy',
                      //   child: Text('Copy'),
                      // ),
                      // if (element.parentId != 0)
                      //   const PopupMenuItem(
                      //     value: 'move',
                      //     child: Text('Move'),
                      //   ),
                      if (element.parentId != 0)
                        const PopupMenuItem(
                          value: 'rename',
                          child: Text('Rename'),
                        ),
                      if (element.parentId != 0)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
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

void _onFolderPopupMenuSelected(value, Folder element, BuildContext context,
    DocumentsController controller) async {
  switch (value) {
    case 'copyLink':
      var portalDomain = controller.portalInfoController.portalUri;

      var link = '${portalDomain}Products/Files/#${element.id.toString()}';

      if (link != null) {
        await Clipboard.setData(ClipboardData(text: link));
        ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
            context: context, text: 'Link has been copied to the clipboard'));
      }
      break;
    case 'open':
      await Get.to(FolderContentView(),
          preventDuplicates: false,
          arguments: {'folderName': element.title, 'folderId': element.id});
      break;
    case 'download':
      controller.downloadFolder();
      break;
    case 'copy':
      controller.copyFolder();
      break;
    case 'move':
      await Get.to(MoveFolderView(),
          preventDuplicates: false, arguments: {'element': element});

      break;
    case 'rename':
      _renameFolder(controller, element, context);
      break;
    case 'delete':
      var success = await controller.deleteFolder(element);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            styledSnackBar(context: context, text: 'File had been deleted'));
        Future.delayed(const Duration(milliseconds: 500),
            () => controller.refreshContent());
      }
      break;
    default:
  }
}

void _onFilePopupMenuSelected(value, PortalFile element, BuildContext context,
    DocumentsController controller) async {
  switch (value) {
    case 'copyLink':
      var portalDomain = controller.portalInfoController.portalUri;

      var link =
          '${portalDomain}Products/Files/DocEditor.aspx?fileid=${element.id.toString()}';

      if (link != null) {
        await Clipboard.setData(ClipboardData(text: link));
        ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
            context: context, text: 'Link has been copied to the clipboard'));
      }
      break;
    case 'open':
      break;
    case 'download':
      break;
    case 'copy':
      break;
    case 'move':
      break;
    case 'rename':
      _renameFile(controller, element, context);
      break;
    case 'delete':
      var success = await controller.deleteFile(element);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            styledSnackBar(context: context, text: 'File had been deleted'));
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
      titleText: 'Rename folder',
      content: TextField(
        autofocus: true,
        textInputAction: TextInputAction.search,
        controller: inputController,
        decoration:
            const InputDecoration.collapsed(hintText: 'Enter folder name'),
        onSubmitted: (value) {
          controller.newSearch(value);
        },
      ),
      acceptText: 'CONFIRM',
      cancelText: 'CANCEL',
      onAcceptTap: () async {
        if (inputController.text != element.title) {
          var success =
              await controller.renameFolder(element, inputController.text);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
                context: context, text: 'Folder had been renamed'));
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
    DocumentsController controller, PortalFile element, BuildContext context) {
  var inputController = TextEditingController();
  inputController.text = element.title.replaceAll(element.fileExst, '');

  Get.dialog(
    StyledAlertDialog(
      titleText: 'Rename file',
      content: TextField(
        autofocus: true,
        textInputAction: TextInputAction.search,
        controller: inputController,
        decoration:
            const InputDecoration.collapsed(hintText: 'Enter file name'),
        onSubmitted: (value) {
          controller.newSearch(value);
        },
      ),
      acceptText: 'CONFIRM',
      cancelText: 'CANCEL',
      onAcceptTap: () async {
        if (inputController.text != element.title) {
          var success =
              await controller.renameFile(element, inputController.text);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
                context: context, text: 'File had been renamed'));
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
