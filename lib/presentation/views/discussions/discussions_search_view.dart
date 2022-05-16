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
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/domain/controllers/discussions/discussion_search_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_detailed.dart';
import 'package:projects/presentation/views/discussions/discussion_tile.dart';

class DiscussionsSearchScreen extends StatelessWidget {
  const DiscussionsSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiscussionSearchController());
    final platformController = Get.find<PlatformController>();

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
      body: Obx(
        () {
          if (!controller.loaded.value) return const ListLoadingSkeleton();
          if (controller.nothingFound.value)
            return const NothingFound();
          else {
            final scrollController = ScrollController();
            return PaginationListView(
              scrollController: scrollController,
              paginationController: controller.paginationController,
              child: ListView.separated(
                controller: scrollController,
                itemCount: controller.paginationController.data.length,
                separatorBuilder: (_, i) => !platformController.isMobile
                    ? const StyledDivider(leftPadding: 72)
                    : const SizedBox(),
                itemBuilder: (BuildContext context, int index) {
                  final discussion = controller.paginationController.data[index];

                  DiscussionItemController discussionItemController;
                  if (Get.isRegistered<DiscussionItemController>(tag: discussion.id.toString()))
                    discussionItemController =
                        Get.find<DiscussionItemController>(tag: discussion.id.toString());
                  else {
                    discussionItemController = Get.put<DiscussionItemController>(
                        DiscussionItemController(),
                        tag: discussion.id.toString());
                    discussionItemController.setup(discussion);
                  }

                  return DiscussionTile(
                    controller: discussionItemController,
                    onTap: () => Get.find<NavigationController>().to(DiscussionDetailed(),
                        arguments: {'controller': discussionItemController}),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
