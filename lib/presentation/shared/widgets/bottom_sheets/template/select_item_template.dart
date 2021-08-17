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
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

class SelectItemTemplate extends StatelessWidget {
  const SelectItemTemplate({
    Key key,
    @required this.searchController,
    @required this.titleText,
    @required this.body,
  }) : super(key: key);

  final BaseSearchController searchController;
  final String titleText;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    const searchIconKey = Key('srch');
    const clearIconKey = Key('clr');

    return Scaffold(
      appBar: StyledAppBar(
        title: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutSine,
            switchOutCurve: Curves.fastOutSlowIn,
            child: searchController.switchToSearchView.value == true
                ? TextField(
                    autofocus: true,
                    controller: searchController.textController,
                    decoration:
                        InputDecoration.collapsed(hintText: tr('enterQuery')),
                    style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onSurface,
                    ),
                    // onSubmitted: onSubmitted,
                    onSubmitted: (value) async =>
                        await searchController.search(query: value),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Text(titleText),
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
              child: searchController.switchToSearchView.value == true
                  ? IconButton(
                      key: searchIconKey,
                      onPressed: () {
                        searchController.switchToSearchView.value =
                            !searchController.switchToSearchView.value;
                        searchController.textController.clear();
                        searchController.clearSearch();
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : IconButton(
                      key: clearIconKey,
                      onPressed: () => searchController.switchToSearchView
                          .value = !searchController.switchToSearchView.value,
                      icon: const Icon(Icons.search),
                    ),
            ),
          ),
        ],
      ),
      body: body,
    );
  }
}

mixin SelectItemMixin on StatelessWidget {
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

    return Scaffold(
      appBar: StyledAppBar(
        title: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutSine,
            switchOutCurve: Curves.fastOutSlowIn,
            child: searchController.switchToSearchView.value == true
                ? TextField(
                    autofocus: true,
                    controller: searchController.textController,
                    decoration:
                        InputDecoration.collapsed(hintText: tr('enterQuery')),
                    style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onSurface,
                    ),
                    onSubmitted: (value) async =>
                        await searchController.search(query: value),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Text(appBarText),
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
              child: searchController.switchToSearchView.value == true
                  ? IconButton(
                      key: _searchIconKey,
                      onPressed: () {
                        searchController.switchToSearchView.value =
                            !searchController.switchToSearchView.value;
                        searchController.textController.clear();
                        searchController.clearSearch();
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : IconButton(
                      key: _clearIconKey,
                      onPressed: () => searchController.switchToSearchView
                          .value = !searchController.switchToSearchView.value,
                      icon: const Icon(Icons.search),
                    ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.loaded.value &&
              searchController.textController.text.isEmpty) return itemList;

          if (searchController.hasResult) return searchResult;
          if (searchController.nothingFound) return nothingFound;

          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}
