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
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/documents/discussions_documents_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/documents/documents_sort_options.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';
import 'package:projects/presentation/views/documents/filter/documents_filter.dart';

class EntityDocumentsView extends StatelessWidget {
  final String folderName;
  final int folderId;
  final DocumentsController documentsController;

  EntityDocumentsView(
      {Key key, this.folderName, this.folderId, this.documentsController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();
    var elevation = ValueNotifier<double>(0);

    scrollController.addListener(
        () => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return DocumentsScreen(
      controller: documentsController,
      scrollController: scrollController,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 50),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, value, __) => StyledAppBar(
            title: _DocsTitle(controller: documentsController),
            showBackButton: false,
            titleHeight: 50,
            elevation: value,
          ),
        ),
      ),
    );
  }
}

class TaskDocumentsView extends StatelessWidget {
  final String folderName;
  final int folderId;
  final DocumentsController documentsController;

  TaskDocumentsView(
      {Key key, this.folderName, this.folderId, this.documentsController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();
    var elevation = ValueNotifier<double>(0);

    scrollController.addListener(
        () => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return DocumentsScreen(
      controller: documentsController,
      scrollController: scrollController,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 0),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, value, __) => StyledAppBar(
            showBackButton: false,
            titleHeight: 0,
            elevation: value,
          ),
        ),
      ),
    );
  }
}

class DiscussionsDocumentsView extends StatelessWidget {
  final List<PortalFile> files;
  DiscussionsDocumentsView({Key key, this.files}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final documentsController = Get.find<DiscussionsDocumentsController>();
    final discussionController = Get.find<DiscussionItemController>();

    var scrollController = ScrollController();
    var elevation = ValueNotifier<double>(0);

    scrollController.addListener(
        () => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return Obx(
      () {
        if (discussionController.loaded.value == true) {
          documentsController.setupFiles(files);
          return PreferredSize(
            preferredSize: const Size(double.infinity, 101),
            child: ValueListenableBuilder(
              valueListenable: elevation,
              builder: (_, value, __) => DocumentsScreen(
                controller: documentsController,
                scrollController: scrollController,
                appBar: StyledAppBar(
                  showBackButton: false,
                  titleHeight: 0,
                  elevation: value,
                ),
              ),
            ),
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}

class _DocsTitle extends StatelessWidget {
  const _DocsTitle({Key key, @required this.controller}) : super(key: key);
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: sortButton,
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
                        'entityType': controller.entityType,
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
