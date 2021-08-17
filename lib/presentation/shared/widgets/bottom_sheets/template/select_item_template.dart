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
