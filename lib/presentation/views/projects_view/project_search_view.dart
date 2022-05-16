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
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_search_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';

class ProjectSearchView extends StatelessWidget {
  ProjectSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platformController = Get.find<PlatformController>();

    final args = ModalRoute.of(context)!.settings.arguments ?? Get.arguments;
    final filtersController = args['filtersController'] as ProjectsFilterController;
    final sortController = args['sortController'] as ProjectsSortController;

    final controller = Get.put(
      ProjectSearchController(
        filterController: filtersController,
        sortController: sortController,
      ),
    );

    return Scaffold(
      appBar: StyledAppBar(
        title: SearchField(
          controller: controller.textController,
          margin: const EdgeInsets.only(right: 16, top: 4),
          autofocus: true,
          hintText: tr('enterQuery'),
          onSubmitted: controller.newSearch,
          onChanged: controller.newSearch,
          onClearPressed: controller.clearSearch,
        ),
      ),
      body: Obx(() {
        if (!controller.loaded.value) return const ListLoadingSkeleton();
        if (controller.nothingFound)
          return const NothingFound();
        else
          return StyledSmartRefresher(
            enablePullDown: false,
            enablePullUp: controller.paginationController.pullUpEnabled,
            controller: controller.paginationController.refreshController,
            onLoading: controller.paginationController.onLoading,
            child: ListView.separated(
              separatorBuilder: (_, i) => !platformController.isMobile
                  ? const StyledDivider(leftPadding: 72)
                  : const SizedBox(),
              itemBuilder: (c, i) => ProjectCell(projectDetails: controller.itemList[i]),
              itemCount: controller.itemList.length,
            ),
          );
      }),
    );
  }
}
