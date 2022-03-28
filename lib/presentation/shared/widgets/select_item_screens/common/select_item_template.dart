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
import 'package:projects/domain/controllers/base/base_search_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_text_field.dart';

part 'app_bar_icon.dart';
part 'app_bar_title.dart';

mixin SelectItemWithSearchMixin on StatelessWidget {
  String get appBarText;

  BaseSearchController get searchController;

  dynamic get controller;

  Widget get itemList;
  Widget get searchResult;
  Widget get nothingFound;

  VoidCallback get getItemsFunction;

  Key get _searchIconKey => const Key('srch');
  Key get _clearIconKey => const Key('clr');

  @override
  Widget build(BuildContext context) {
    getItemsFunction();
    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
        title: _AppBarTitle(
          appBarText: appBarText,
          searchController: searchController,
        ),
        centerTitle: !GetPlatform.isAndroid,
        actions: [
          _AppBarIcon(
            searchController: searchController,
            searchIconKey: _searchIconKey,
            clearIconKey: _clearIconKey,
          )
        ],
      ),
      body: Obx(
        () {
          if (controller.loaded.value as bool && searchController.textController.text.isEmpty)
            return itemList;

          if (searchController.hasResult) return searchResult;
          if (searchController.nothingFound) return nothingFound;

          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}

mixin SelectItemMixin on StatelessWidget {
  String get appBarText;

  // ignore: always_declare_return_types
  get controller;

  Widget get itemList;

  VoidCallback get getItemsFunction;

  @override
  Widget build(BuildContext context) {
    getItemsFunction();
    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        titleText: appBarText,
        backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
      ),
      body: Obx(
        () {
          if (controller.loaded.value as bool) return itemList;
          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}

mixin SelectItemListMixin on StatelessWidget {
  PaginationController get paginationController;

  Widget Function(BuildContext context, int index) get itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (paginationController.data.isEmpty) {
        return Center(child: EmptyScreen(icon: SvgIcons.group, text: tr('noGroups')));
      } else {
        final scrollController = ScrollController();

        return PaginationListView(
          scrollController: scrollController,
          paginationController: paginationController,
          child: ListView.separated(
            controller: scrollController,
            itemCount: paginationController.data.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            separatorBuilder: (BuildContext context, int index) {
              return const StyledDivider(
                leftPadding: 16,
                rightPadding: 16,
              );
            },
            itemBuilder: itemBuilder,
          ),
        );
      }
    });
  }
}

class SelectItemTile extends StatelessWidget {
  const SelectItemTile({
    Key? key,
    required this.title,
    required this.onSelect,
  }) : super(key: key);

  final String? title;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title!,
                    style: TextStyleHelper.subtitle1(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
