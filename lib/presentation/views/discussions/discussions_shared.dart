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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/domain/controllers/discussions/base_discussions_controller.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/context_menu/platform_context_menu_button.dart';
import 'package:projects/presentation/shared/widgets/context_menu/platform_context_menu_item.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/views/discussions/discussion_tile.dart';
import 'package:projects/presentation/views/discussions/filter/discussions_filter_screen.dart';

class DiscussionsContent extends StatelessWidget {
  const DiscussionsContent({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BaseDiscussionsController controller;

  @override
  Widget build(BuildContext context) {
    final platformController = Get.find<PlatformController>();

    return Obx(() {
      if (!controller.loaded.value) return const ListLoadingSkeleton();

      final scrollController = ScrollController();
      return PaginationListView(
          scrollController: scrollController,
          paginationController: controller.paginationController,
          child: () {
            if (controller.loaded.value &&
                controller.itemList.isEmpty &&
                !controller.filterController.hasFilters.value)
              return Center(
                child: EmptyScreen(
                  icon: SvgIcons.comments_not_created,
                  text: tr('noDiscussionsCreated'),
                ),
              );
            if (controller.loaded.value &&
                controller.itemList.isEmpty &&
                controller.filterController.hasFilters.value)
              return Center(
                child: EmptyScreen(
                  icon: SvgIcons.not_found,
                  text: tr('noDiscussionsMatching'),
                ),
              );
            if (controller.loaded.value && controller.itemList.isNotEmpty)
              return ListView.separated(
                controller: scrollController,
                itemCount: controller.itemList.length,
                separatorBuilder: (_, i) => !platformController.isMobile
                    ? const StyledDivider(leftPadding: 72)
                    : const SizedBox(),
                itemBuilder: (_, index) {
                  final discussion = controller.itemList[index] as Discussion;

                  DiscussionItemController discussionItemController;
                  if (Get.isRegistered<DiscussionItemController>(tag: discussion.id.toString()))
                    discussionItemController =
                        Get.find<DiscussionItemController>(tag: discussion.id.toString());
                  else {
                    discussionItemController = Get.put<DiscussionItemController>(
                        DiscussionItemController(),
                        tag: discussion.id.toString());
                  }

                  discussionItemController.setup(discussion);

                  return DiscussionTile(
                    controller: discussionItemController,
                    onTap: () => controller.toDetailed(discussionItemController),
                  );
                },
              );
          }() as Widget);
    });
  }
}

class DiscussionsFilterButton extends StatelessWidget {
  const DiscussionsFilterButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BaseDiscussionsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.itemList.isNotEmpty || controller.filterController.hasFilters.value)
        return PlatformIconButton(
          icon: FiltersButton(controller: controller),
          onPressed: () async => Get.find<NavigationController>().toScreen(
            const DiscussionsFilterScreen(),
            preventDuplicates: false,
            arguments: {'filterController': controller.filterController},
            transition: Transition.cupertinoDialog,
            fullscreenDialog: true,
            page: '/DiscussionsFilterScreen',
          ),
          cupertino: (_, __) => CupertinoIconButtonData(minSize: 36),
          padding: EdgeInsets.zero,
        );
      return const SizedBox();
    });
  }
}

class DiscussionsMoreButtonWidget extends StatelessWidget {
  const DiscussionsMoreButtonWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BaseDiscussionsController controller;

  @override
  Widget build(BuildContext context) {
    return PlatformPopupMenuButton(
      padding: EdgeInsets.zero,
      icon: PlatformIconButton(
        padding: EdgeInsets.zero,
        cupertinoIcon: Icon(
          CupertinoIcons.ellipsis_circle,
          color: Get.theme.colors().primary,
        ),
        materialIcon: Icon(
          Icons.more_vert,
          color: Get.theme.colors().primary,
        ),
        cupertino: (_, __) => CupertinoIconButtonData(minSize: 36),
      ),
      itemBuilder: (context) {
        return [
          for (final tile in controller.sortController.getSortTile())
            PlatformPopupMenuItem(
              onTap: () {
                tile.sortController.changeSort(tile.sortParameter);
                Get.back();
              },
              child: tile,
            ),
        ];
      },
    );
  }
}
