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
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/domain/controllers/documents/base_documents_controller.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/mixins/show_popup_menu_mixin.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/views/documents/file_cell.dart';
import 'package:projects/presentation/views/documents/filter/documents_filter_screen.dart';
import 'package:projects/presentation/views/documents/folder_cell.dart';

class ProjectDocumentsScreen extends StatelessWidget {
  const ProjectDocumentsScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BaseDocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return _Content(controller: controller);
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BaseDocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (!controller.loaded.value) return const ListLoadingSkeleton();

        return PaginationListView(
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
                  !controller.searchMode.value) {
                return Center(
                    child: EmptyScreen(icon: SvgIcons.not_found, text: tr('noDocumentsMatching')));
              }
              if (controller.loaded.value && controller.paginationController.data.isNotEmpty)
                return ListView.separated(
                  controller: ScrollController(),
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
                            entity: element as PortalFile,
                            index: index,
                            controller: controller as DocumentsController,
                          );
                  },
                );
            }() as Widget);
      },
    );
  }
}

class ProjectDocumentsFilterButton extends StatelessWidget {
  const ProjectDocumentsFilterButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final DocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      icon: FiltersButton(controller: controller),
      onPressed: () async => Get.find<NavigationController>().toScreen(
        const DocumentsFilterScreen(),
        preventDuplicates: false,
        arguments: {'filterController': controller.filterController},
      ),
    );
  }
}

class ProjectDocumentsSortButton extends StatelessWidget with ShowPopupMenuMixin {
  const ProjectDocumentsSortButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final DocumentsController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

void documentsSortButtonOnPressed(DocumentsController controller, BuildContext context) async {
  Future<void> showPopupMenu(
      {required BuildContext context,
      required List<Widget> options,
      required Offset offset}) async {
    final items = options.map((e) => PopupMenuItem(child: e)).toList();

    // calculate the menu position, offset dy: 50
    // final offset = const Offset(0, 50);
    final button = context.findRenderObject() as RenderBox;
    final overlay = Get.overlayContext!.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          offset,
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + offset,
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    await showMenu(context: context, position: position, items: items);
  }

  List<SortTile> _getSortTile() {
    return [
      SortTile(sortParameter: 'dateandtime', sortController: controller.sortController),
      SortTile(sortParameter: 'create_on', sortController: controller.sortController),
      SortTile(sortParameter: 'AZ', sortController: controller.sortController),
      SortTile(sortParameter: 'type', sortController: controller.sortController),
      SortTile(sortParameter: 'size', sortController: controller.sortController),
      SortTile(sortParameter: 'author', sortController: controller.sortController),
    ];
  }

  if (Get.find<PlatformController>().isMobile) {
    final options = Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        ..._getSortTile(),
        const SizedBox(height: 20)
      ],
    );
    await Get.bottomSheet(SortView(sortOptions: options), isScrollControlled: true);
  } else {
    await showPopupMenu(
      context: context,
      options: _getSortTile(),
      offset: const Offset(0, 30),
    );
  }
}
