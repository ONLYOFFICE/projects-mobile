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

import 'dart:core';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/domain/controllers/documents/base_documents_controller.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/documents/file_cell_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/mixins/show_popup_menu_mixin.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_searchbar.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/views/documents/documents_sort_options.dart';
import 'package:projects/presentation/views/documents/file_cell.dart';
import 'package:projects/presentation/views/documents/filter/documents_filter_screen.dart';
import 'package:projects/presentation/views/documents/folder_cell.dart';
import 'package:projects/presentation/views/project_detailed/project_documents_view.dart';

class PortalDocumentsView extends StatelessWidget {
  const PortalDocumentsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      controller.initialSetup();
    });

    return DocumentsScreen(
      controller: controller,
    );
  }
}

class FolderContentView extends StatelessWidget {
  FolderContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>();
    final folderName = Get.arguments['folderName'] as String?;
    final folderId = Get.arguments['folderId'] as int?;

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      controller.setupFolder(folderName: folderName!, folderId: folderId);
    });

    return DocumentsScreen(
      controller: controller,
      isCollapsed: true,
    );
  }
}

class DocumentsSearchView extends StatelessWidget {
  DocumentsSearchView({Key? key}) : super(key: key);

  final documentsController = Get.find<DocumentsController>();

  @override
  Widget build(BuildContext context) {
    final folderName = Get.arguments['folderName'] as String?;
    final folderId = Get.arguments['folderId'] as int?;

    documentsController.entityType = Get.arguments['entityType'] as String?;

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      documentsController.setupSearchMode(folderName: folderName, folderId: folderId);
    });

    return ProjectDocumentsScreen(
      controller: documentsController,
      appBar: StyledAppBar(
        title: CustomSearchBar(controller: documentsController),
        showBackButton: true,
        titleHeight: 50,
      ),
      //isCollapsed: true,
    );
  }
}

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({
    Key? key,
    required this.controller,
    this.isCollapsed = false,
  }) : super(key: key);

  final BaseDocumentsController controller;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Get.theme.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            MainAppBar(
              isCollapsed: isCollapsed,
              materialTitle: Obx(
                () => Text(
                  controller.documentsScreenName.value,
                  style: TextStyleHelper.headerStyle(color: Get.theme.colors().onSurface),
                ),
              ),
              cupertinoTitle: Obx(
                () => Text(
                  controller.documentsScreenName.value,
                  style: TextStyle(color: Get.theme.colors().onSurface),
                ),
              ),
              actions: [
                _SearchButtonWidget(controller: controller),
                _FilterButtonWidget(controller: controller),
                const _MoreButtonWidget(),
              ],
            ),
          ];
        },
        body: Obx(
          () {
            if (!controller.loaded.value) return const ListLoadingSkeleton();

            if (controller.loaded.value && controller.nothingFound.value) {
              return Center(child: EmptyScreen(icon: SvgIcons.not_found, text: tr('notFound')));
            } else if (controller.loaded.value &&
                controller.paginationController.data.isEmpty &&
                !controller.filterController.hasFilters.value &&
                !controller.searchMode.value) {
              return Center(
                  child: EmptyScreen(
                      icon: SvgIcons.documents_not_created, text: tr('noDocumentsCreated')));
            } else if (controller.loaded.value &&
                controller.paginationController.data.isEmpty &&
                controller.filterController.hasFilters.value &&
                !controller.searchMode.value) {
              return Center(
                  child: EmptyScreen(icon: SvgIcons.not_found, text: tr('noDocumentsMatching')));
            } else
              return ListView.separated(
                itemCount: controller.paginationController.data.length,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                itemBuilder: (BuildContext context, int index) {
                  final element = controller.paginationController.data[index];
                  return element is Folder
                      ? FolderCell(
                          entity: element,
                          controller: controller as DocumentsController,
                        )
                      : FileCell(
                          cellController: FileCellController(portalFile: element as PortalFile),
                          documentsController: controller as DocumentsController,
                        );
                },
              );
          },
        ),
      ),
    );
  }
}

class _MoreButtonWidget extends StatelessWidget {
  const _MoreButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      onPressed: () {},
      cupertino: (_, __) {
        return CupertinoIconButtonData(
          icon: Icon(
            CupertinoIcons.ellipsis_circle,
            color: Get.theme.colors().primary,
          ),
          color: Get.theme.colors().background,
          onPressed: () {},
          padding: EdgeInsets.zero,
        );
      },
      materialIcon: Icon(
        Icons.more_vert,
        color: Get.theme.colors().primary,
      ),
    );
  }
}

class _FilterButtonWidget extends StatelessWidget {
  const _FilterButtonWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BaseDocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      onPressed: () async => Get.find<NavigationController>().toScreen(
          const DocumentsFilterScreen(),
          preventDuplicates: false,
          arguments: {'filterController': controller.filterController}),
      materialIcon: FiltersButton(controller: controller),
      cupertino: (_, __) {
        return CupertinoIconButtonData(
          icon: FiltersButton(controller: controller),
          color: Get.theme.colors().background,
          onPressed: () async => Get.find<NavigationController>().toScreen(
              const DocumentsFilterScreen(),
              preventDuplicates: false,
              arguments: {'filterController': controller.filterController}),
          padding: EdgeInsets.zero,
        );
      },
    );
  }
}

class _SearchButtonWidget extends StatelessWidget {
  const _SearchButtonWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BaseDocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      onPressed: () {
        Get.find<NavigationController>()
            .to(DocumentsSearchView(), preventDuplicates: false, arguments: {
          'folderName': controller.documentsScreenName.value,
          'folderId': controller.currentFolderID,
          'documentsController': controller,
        });
      },
      cupertino: (_, __) {
        return CupertinoIconButtonData(
          icon: AppIcon(
            icon: SvgIcons.search,
            color: Get.theme.colors().primary,
          ),
          color: Get.theme.colors().background,
          onPressed: () {
            Get.find<NavigationController>()
                .to(DocumentsSearchView(), preventDuplicates: false, arguments: {
              'folderName': controller.documentsScreenName.value,
              'folderId': controller.currentFolderID,
              'documentsController': controller,
            });
          },
          padding: EdgeInsets.zero,
        );
      },
      materialIcon: AppIcon(
        icon: SvgIcons.search,
        color: Get.theme.colors().primary,
      ),
    );
  }
}

class DocsTitle extends StatelessWidget {
  const DocsTitle({Key? key, required this.controller}) : super(key: key);
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
                controller.documentsScreenName.value,
                style: TextStyleHelper.headerStyle(color: Get.theme.colors().onSurface),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkResponse(
                onTap: () {
                  Get.find<NavigationController>()
                      .to(DocumentsSearchView(), preventDuplicates: false, arguments: {
                    'folderName': controller.documentsScreenName.value,
                    'folderId': controller.currentFolderID,
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
                    arguments: {'filterController': controller.filterController}),
                child: FiltersButton(controller: controller),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DocsBottom extends StatelessWidget {
  DocsBottom({Key? key, required this.controller}) : super(key: key);
  final BaseDocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _DocumentsSortButton(controller: controller),
              Row(
                children: <Widget>[
                  Obx(
                    () => Text(
                      tr('total', args: [controller.paginationController.total.value.toString()]),
                      style: TextStyleHelper.body2(
                        color: Get.theme.colors().onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocumentsSortButton extends StatelessWidget with ShowPopupMenuMixin {
  const _DocumentsSortButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BaseDocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 4),
      child: InkResponse(
        onTap: () async {
          if (Get.find<PlatformController>().isMobile) {
            await Get.bottomSheet(
              SortView(sortOptions: DocumentsSortOption(controller: controller)),
              isScrollControlled: true,
            );
          } else {
            final options = [
              SortTile(
                sortParameter: 'dateandtime',
                sortController: controller.sortController,
              ),
              SortTile(
                sortParameter: 'create_on',
                sortController: controller.sortController,
              ),
              SortTile(
                sortParameter: 'AZ',
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
            ];
            await showPopupMenu(
              context: context,
              options: options,
              offset: const Offset(0, 30),
            );
          }
        },
        child: Row(
          children: <Widget>[
            Obx(
              () => Text(
                controller.sortController.currentSortTitle.value,
                style: TextStyleHelper.projectsSorting.copyWith(color: Get.theme.colors().primary),
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
  }
}

class CupertinoCollapsedNavBar extends SliverPersistentHeaderDelegate {
  const CupertinoCollapsedNavBar({required this.controller, required this.persistentHeight});

  final BaseDocumentsController controller;
  final double persistentHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return CupertinoNavigationBar(
      backgroundColor: Get.theme.colors().background,
      middle: Obx(
        () => Text(
          controller.documentsScreenName.value,
          style: TextStyle(color: Get.theme.colors().onSurface),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: AppIcon(
              width: 24,
              height: 24,
              icon: SvgIcons.search,
              color: Get.theme.colors().primary,
            ),
            onPressed: () {
              Get.find<NavigationController>()
                  .to(DocumentsSearchView(), preventDuplicates: false, arguments: {
                'folderName': controller.documentsScreenName.value,
                'folderId': controller.currentFolderID,
                'documentsController': controller,
              });
            },
          ),
          IconButton(
            icon: FiltersButton(controller: controller),
            onPressed: () async => Get.find<NavigationController>().toScreen(
                const DocumentsFilterScreen(),
                preventDuplicates: false,
                arguments: {'filterController': controller.filterController}),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.ellipsis_circle, color: Get.theme.colors().primary, size: 24),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => persistentHeight;

  @override
  double get minExtent => persistentHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}
