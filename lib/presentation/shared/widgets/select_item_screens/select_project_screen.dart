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
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/project_search_controller.dart';
import 'package:projects/internal/utils/name_formatter.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/common/select_item_template.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';

class SelectProjectScreen extends StatelessWidget {
  SelectProjectScreen({Key? key}) : super(key: key);

  final searchController = Get.put(ProjectSearchController());

  void onSelect(ProjectDetailed project) {
    Get.back(result: {
      'id': project.id,
      'title': project.title,
    });
    searchController.clearSearch();
  }

  final _platformController = Get.find<PlatformController>();

  @override
  Widget build(BuildContext context) {
    searchController.refreshData();

    return Scaffold(
      backgroundColor: _platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        backgroundColor: _platformController.isMobile ? null : Get.theme.colors().surface,
        showBackButton: true,
        centerTitle: !GetPlatform.isAndroid,
        title: AppBarTitleWithSearch(
          appBarText: tr('selectProject'),
          searchController: searchController,
        ),
        actions: [
          AppBarSearchItem(searchController: searchController),
        ],
      ),
      body: Obx(
        () {
          final scrollController = ScrollController();

          return PaginationListView(
              scrollController: scrollController,
              paginationController: searchController.paginationController,
              child: () {
                if (!searchController.loaded.value) return const ListLoadingSkeleton();

                if (searchController.nothingFound) return const NothingFound();

                return ListView.separated(
                  controller: scrollController,
                  itemCount: searchController.itemList.length,
                  padding: const EdgeInsets.only(bottom: 16),
                  separatorBuilder: (BuildContext context, int index) {
                    return const StyledDivider(
                      leftPadding: 16,
                      rightPadding: 16,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return _ProjectTile(
                      project: searchController.itemList[index],
                      onPressed: () => onSelect(searchController.itemList[index]),
                    );
                  },
                );
              }());
        },
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({
    Key? key,
    required this.project,
    required this.onPressed,
  }) : super(key: key);

  final ProjectDetailed project;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    project.title!,
                    style: TextStyleHelper.subtitle1(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    NameFormatter.formateName(project.responsible!)!,
                    style: TextStyleHelper.projectResponsible,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
