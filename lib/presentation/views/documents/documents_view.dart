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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_searchbar.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/documents/documents_sort_options.dart';
import 'package:projects/presentation/views/documents/file_cell.dart';
import 'package:projects/presentation/views/documents/filter/documents_filter_screen.dart';
import 'package:projects/presentation/views/documents/folder_cell.dart';

class PortalDocumentsView extends StatelessWidget {
  const PortalDocumentsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      controller.initialSetup();
    });

    var scrollController = ScrollController();
    var elevation = ValueNotifier<double>(0);

    scrollController.addListener(
        () => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return DocumentsScreen(
      controller: controller,
      scrollController: scrollController,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 101),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, dynamic value, __) => StyledAppBar(
            title: DocsTitle(controller: controller),
            bottom: DocsBottom(controller: controller),
            showBackButton: false,
            titleHeight: 50,
            bottomHeight: 50,
            elevation: value,
          ),
        ),
      ),
    );
  }
}

class FolderContentView extends StatelessWidget {
  FolderContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>();
    final String? folderName = Get.arguments['folderName'];
    final int? folderId = Get.arguments['folderId'];

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      controller.setupFolder(folderName: folderName!, folderId: folderId);
    });

    var scrollController = ScrollController();
    var elevation = ValueNotifier<double>(0);

    scrollController.addListener(
        () => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return DocumentsScreen(
      controller: controller,
      scrollController: scrollController,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 101),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, dynamic value, __) => StyledAppBar(
            title: DocsTitle(controller: controller),
            bottom: DocsBottom(controller: controller),
            showBackButton: true,
            titleHeight: 50,
            bottomHeight: 50,
          ),
        ),
      ),
    );
  }
}

class DocumentsSearchView extends StatelessWidget {
  DocumentsSearchView({Key? key}) : super(key: key);

  final documentsController = Get.find<DocumentsController>();

  @override
  Widget build(BuildContext context) {
    final String? folderName = Get.arguments['folderName'];
    final int? folderId = Get.arguments['folderId'];

    documentsController.entityType = Get.arguments['entityType'];

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      documentsController.setupSearchMode(
          folderName: folderName, folderId: folderId);
    });

    return DocumentsScreen(
      controller: documentsController,
      scrollController: ScrollController(),
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
    Key? key,
    required this.controller,
    required this.scrollController,
    this.appBar,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final controller;
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
          return PaginationListView(
            paginationController: controller.paginationController,
            child: ListView.separated(
              controller: scrollController,
              itemCount: controller.paginationController.data.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                var element = controller.paginationController.data[index];
                return element is Folder
                    ? FolderCell(
                        entity: element,
                        controller: controller,
                      )
                    : FileCell(
                        entity: element,
                        index: index,
                        controller: controller,
                      );
              },
            ),
          );
        },
      ),
    );
  }
}

class DocsTitle extends StatelessWidget {
  const DocsTitle({Key? key, required this.controller}) : super(key: key);
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
                  Get.find<NavigationController>().to(DocumentsSearchView(),
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

class DocsBottom extends StatelessWidget {
  DocsBottom({Key? key, this.controller}) : super(key: key);
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
                style: TextStyleHelper.projectsSorting
                    .copyWith(color: Get.theme.colors().primary),
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => (controller.sortController.currentSortOrder == 'ascending')
                  ? AppIcon(
                      icon: SvgIcons.sorting_4_ascend,
                      color: Get.theme.colors().primary,
                      width: 20,
                      height: 20,
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(math.pi),
                      child: AppIcon(
                        icon: SvgIcons.sorting_4_ascend,
                        color: Get.theme.colors().primary,
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
                          color: Get.theme.colors().onSurface.withOpacity(0.6),
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
