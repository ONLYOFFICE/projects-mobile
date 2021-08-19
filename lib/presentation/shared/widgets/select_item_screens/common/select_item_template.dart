import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base/base_search_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';

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

    return Scaffold(
      appBar: StyledAppBar(
        title: _AppBarTitle(
          appBarText: appBarText,
          searchController: searchController,
        ),
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

mixin SelectItemMixin on StatelessWidget {
  String get appBarText;

  // ignore: always_declare_return_types
  get controller;

  Widget get itemList;

  VoidCallback get getItemsFunction;

  @override
  Widget build(BuildContext context) {
    getItemsFunction();

    return Scaffold(
      appBar: StyledAppBar(titleText: appBarText),
      body: Obx(
        () {
          if (controller.loaded.value) return itemList;
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
    return Obx(
      () => PaginationListView(
        paginationController: paginationController,
        child: ListView.separated(
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
      ),
    );
  }
}

class SelectItemTile extends StatelessWidget {
  const SelectItemTile({
    Key key,
    @required this.title,
    @required this.onSelect,
  }) : super(key: key);

  final String title;
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
                    title,
                    style: TextStyleHelper.projectTitle,
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
