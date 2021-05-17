import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/groups_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/milestone_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/projects_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/tags_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/users_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/filters/confirm_filters_button.dart';
import 'package:projects/presentation/shared/widgets/filters/filters_header.dart';
import 'package:projects/presentation/shared/widgets/filters/filters_row.dart';
import 'package:projects/presentation/shared/widgets/filters/filter_element_widget.dart';

part 'filters/responsible.dart';
part 'filters/creator.dart';
part 'filters/project.dart';
part 'filters/milestone.dart';
part 'filters/duedate.dart';

void showFilters(context) async {
  var filterController = Get.find<TaskFilterController>();

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
                const _Responsible(),
                const _Creator(),
                const _Project(),
                const _Milestone(),
                const _DueDate(),
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
