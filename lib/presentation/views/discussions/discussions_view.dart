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
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_filter_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/views/discussions/discussion_tile.dart';
import 'package:projects/presentation/views/discussions/filter/discussions_filter_screen.dart';
import 'package:projects/presentation/views/discussions/widgets/discussions_header.dart';

class PortalDiscussionsView extends StatelessWidget {
  const PortalDiscussionsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DiscussionsController>();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      controller.loadDiscussions(preset: PresetDiscussionFilters.saved);
    });

    final scrollController = ScrollController();
    final elevation = ValueNotifier<double>(0);

    scrollController.addListener(() => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 101),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, double value, __) => StyledAppBar(
            titleHeight: 101,
            bottomHeight: 0,
            showBackButton: false,
            titleText: tr('discussions'),
            elevation: value,
            actions: [
              IconButton(
                icon: AppIcon(
                  width: 24,
                  height: 24,
                  icon: SvgIcons.search,
                  color: Get.theme.colors().primary,
                ),
                onPressed: controller.showSearch,
                // onPressed: () => controller.showSearch(),
              ),
              IconButton(
                  icon: FiltersButton(controler: controller),
                  onPressed: () async => Get.find<NavigationController>().toScreen(
                      const DiscussionsFilterScreen(),
                      preventDuplicates: false,
                      arguments: {'filterController': controller.filterController})),
              const SizedBox(width: 3),
            ],
            bottom: DiscussionsHeader(
              controller: controller,
            ),
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.fabIsVisible.value,
          child: StyledFloatingActionButton(
            onPressed: controller.toNewDiscussionScreen,
            child: AppIcon(
              icon: SvgIcons.add_discussion,
              color: Get.theme.colors().onPrimarySurface,
            ),
          ),
        ),
      ),
      body: DiscussionsList(controller: controller, scrollController: scrollController),
    );
  }
}

class DiscussionsList extends StatelessWidget {
  final controller;
  final ScrollController scrollController;
  const DiscussionsList({
    Key? key,
    required this.controller,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // a temporary solution for the discussion page in projects
    // where there are no filters yet
    var hasFilters = false;
    try {
      hasFilters = controller?.filterController?.hasFilters?.value as bool;
    } catch (_) {}

    return Obx(() {
      if (!(controller.loaded.value as bool)) {
        return const ListLoadingSkeleton();
      }
      return PaginationListView(
          paginationController:
              controller.paginationController as PaginationController,
          child: () {
            if (controller.loaded.value as bool &&
                controller.paginationController.data.isEmpty as bool &&
                hasFilters)
              return Center(
                child: EmptyScreen(
                  icon: SvgIcons.not_found,
                  text: tr('noDiscussionsMatching'),
                ),
              );
            if (controller.loaded.value as bool &&
                controller.paginationController.data.isEmpty as bool)
              return Center(
                child: EmptyScreen(
                  icon: SvgIcons.comments_not_created,
                  text: tr('noDiscussionsCreated'),
                ),
              );
            if (controller.loaded.value as bool &&
                controller.paginationController.data.isNotEmpty as bool)
              return ListView.separated(
                itemCount: controller.paginationController.data.length as int,
                padding: const EdgeInsets.only(bottom: 65),
                controller: scrollController,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 12);
                },
                itemBuilder: (BuildContext context, int index) {
                  return DiscussionTile(
                    discussion: controller.paginationController.data[index]
                        as Discussion,
                    onTap: () => controller.toDetailed(
                        controller.paginationController.data[index]),
                  );
                },
              );
          }() as Widget);
    });
  }
}
