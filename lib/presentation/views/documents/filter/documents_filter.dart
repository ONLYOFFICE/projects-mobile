import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/groups_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/users_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/filters/confirm_filters_button.dart';
import 'package:projects/presentation/shared/widgets/filters/filters_header.dart';
import 'package:projects/presentation/shared/widgets/filters/filters_row.dart';
import 'package:projects/presentation/shared/widgets/filters/filter_element_widget.dart';

part 'filters/type.dart';
part 'filters/search_settings.dart';
part 'filters/author.dart';

void showFilters(context, filterController) async {
  await showStickyFlexibleBottomSheet(
    context: context,
    headerHeight: 84,
    isExpand: true,
    initHeight: 0.9,
    decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
    headerBuilder: (context, bottomSheetOffset) => Container(
      child: FiltersHeader(filterController: filterController),
    ),
    builder: (context, bottomSheetOffset) {
      return SliverChildListDelegate(
        [
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Type(filterController: filterController),
                _Author(filterController: filterController),
                // _SearchSettings(filterController: filterController),
                if (filterController.suitableResultCount.value != -1)
                  ConfirmFiltersButton(filterController: filterController),
              ],
            ),
          )
        ],
      );
    },
  );
}
