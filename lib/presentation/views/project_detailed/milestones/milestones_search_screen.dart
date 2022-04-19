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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestone_search_controller.dart';
import 'package:projects/presentation/shared/widgets/custom_searchbar.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/views/project_detailed/milestones/milestone_cell.dart';

class MileStonesSearchScreen extends StatelessWidget {
  const MileStonesSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MilestoneSearchController());
    final platformController = Get.find<PlatformController>();

    return Scaffold(
      appBar: StyledAppBar(
        title: CustomSearchBar(controller: controller),
      ),
      body: Obx(
        () {
          if (!controller.loaded.value) return const ListLoadingSkeleton();

          if (controller.searchNothingFound.value) return const NothingFound();

          final scrollController = ScrollController();
          return PaginationListView(
            scrollController: scrollController,
            paginationController: controller.paginationController,
            child: () {
              return ListView.separated(
                controller: scrollController,
                separatorBuilder: (_, i) => !platformController.isMobile
                    ? const StyledDivider(leftPadding: 72)
                    : const SizedBox(),
                itemCount: controller.paginationController.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return MilestoneCell(milestone: controller.itemList[index]);
                },
              );
            }(),
          );
        },
      ),
    );
  }
}
