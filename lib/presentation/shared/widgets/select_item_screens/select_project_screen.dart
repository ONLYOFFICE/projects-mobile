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
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/project_search_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/internal/utils/name_formatter.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_text_field.dart';

class SelectProjectScreen extends StatelessWidget {
  SelectProjectScreen({Key? key}) : super(key: key);

  final searchFieldController = TextEditingController();
  final searchController = Get.put(ProjectSearchController());
  final navigationController = Get.find<NavigationController>();

  final _projectsController = Get.put(ProjectsController(), tag: '7');

  void onSelect(ProjectDetailed project) {
    navigationController.back(result: {
      'id': project.id,
      'title': project.title,
    });
    searchController.clearSearch();
    searchFieldController.clear();
  }

  final _platformController = Get.find<PlatformController>();

  @override
  Widget build(BuildContext context) {
    _projectsController.loadProjects();

    const searchIconKey = Key('srh');
    const clearIconKey = Key('clr');

    return Scaffold(
      backgroundColor: _platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        backgroundColor: _platformController.isMobile ? null : Get.theme.colors().surface,
        showBackButton: true,
        onLeadingPressed: navigationController.back,
        centerTitle: !GetPlatform.isAndroid,
        title: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutSine,
            switchOutCurve: Curves.fastOutSlowIn,
            child: searchController.switchToSearchView.isTrue
                ? PlatformTextField(
                    autofocus: true,
                    controller: searchFieldController,
                    hintText: tr('enterQuery'),
                    material: (_, __) => MaterialTextFieldData(
                      decoration: InputDecoration.collapsed(hintText: tr('enterQuery')),
                    ),
                    style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onSurface,
                    ),
                    onSubmitted: searchController.newSearch,
                  )
                : Text(
                    tr('selectProject'),
                    style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface),
                  ),
          ),
        ),
        actions: [
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutSine,
              switchOutCurve: Curves.fastOutSlowIn,
              child: searchController.switchToSearchView.isTrue
                  ? PlatformIconButton(
                      key: searchIconKey,
                      onPressed: () {
                        searchController.switchToSearchView.toggle();
                        searchFieldController.clear();
                        searchController.clearSearch();
                      },
                      icon: Icon(PlatformIcons(context).clear),
                    )
                  : PlatformIconButton(
                      key: clearIconKey,
                      onPressed: () => searchController.switchToSearchView.toggle(),
                      icon: Icon(PlatformIcons(context).search),
                    ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          final scrollController = ScrollController();

          if (searchController.switchToSearchView.value == true &&
              searchController.searchResult.isNotEmpty) {
            return StyledSmartRefresher(
              scrollController: scrollController,
              enablePullDown: false,
              enablePullUp: searchController.pullUpEnabled,
              controller: searchController.refreshController,
              onLoading: searchController.onLoading,
              child: ListView.separated(
                controller: scrollController,
                itemCount: searchController.searchResult.length,
                padding: const EdgeInsets.only(bottom: 16),
                separatorBuilder: (BuildContext context, int index) {
                  return const StyledDivider(
                    leftPadding: 16,
                    rightPadding: 16,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return _ProjectTile(
                    project: searchController.searchResult[index],
                    onPressed: () => onSelect(searchController.searchResult[index]),
                  );
                },
              ),
            );
          }
          if (searchController.switchToSearchView.value == true &&
              searchController.searchResult.isEmpty &&
              searchController.loaded.value == true &&
              searchFieldController.text.isNotEmpty) {
            return const NothingFound();
          }
          if (_projectsController.loaded.value == true) {
            return PaginationListView(
              scrollController: scrollController,
              paginationController: _projectsController.paginationController,
              child: ListView.separated(
                controller: scrollController,
                itemCount: _projectsController.paginationController.data.length,
                padding: const EdgeInsets.only(bottom: 16),
                separatorBuilder: (BuildContext context, int index) {
                  return const StyledDivider(
                    leftPadding: 16,
                    rightPadding: 16,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  final project = _projectsController.paginationController.data[index];
                  return _ProjectTile(
                    project: project,
                    onPressed: () => onSelect(project),
                  );
                },
              ),
            );
          }
          return const ListLoadingSkeleton();
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
