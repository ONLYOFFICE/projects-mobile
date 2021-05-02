import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/tags_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/users_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/filters/confirm_filters_button.dart';
import 'package:projects/presentation/shared/widgets/filters/filters_header.dart';
import 'package:projects/presentation/shared/widgets/filters/filters_row.dart';
import 'package:projects/presentation/shared/widgets/filters/filter_element_widget.dart';

part 'filters/status.dart';
part 'filters/other.dart';
part 'filters/task_responsible.dart';
part 'filters/milestone_responsible.dart';

void showFilters(context) async {
  var filterController = Get.find<MilestonesFilterController>();

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
                const _Status(),
                const _MilestoneResponsible(),
                const _TaskResponsible(),
                //TODO: add due date filter
                // const _Other(),
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
