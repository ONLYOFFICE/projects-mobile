import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';

import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_filter_controller.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/users_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/filters/confirm_filters_button.dart';
import 'package:projects/presentation/shared/widgets/filters/filters_row.dart';
import 'package:projects/presentation/shared/widgets/filters/filter_element_widget.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

part 'filters/status.dart';
part 'filters/duedate.dart';
part 'filters/task_responsible.dart';
part 'filters/milestone_responsible.dart';

class MilestoneFilterScreen extends StatelessWidget {
  const MilestoneFilterScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BaseFilterController filterController =
        Get.find<MilestonesFilterController>();

    return Scaffold(
      appBar: StyledAppBar(
        titleText: 'Filter',
        showBackButton: true,
        actions: [
          TextButton(
              onPressed: () async => filterController.resetFilters(),
              child: Text('RESET',
                  style: TextStyleHelper.button(
                      color: Theme.of(context).customColors().systemBlue)))
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12.5),
                  const _Status(),
                  const _MilestoneResponsible(),
                  const _TaskResponsible(),
                  const _DueDate(),
                ],
              ),
            ),
          ),
          Obx(() {
            if (filterController.suitableResultCount.value != -1)
              return ConfirmFiltersButton(filterController: filterController);
            return const SizedBox();
          }),
        ],
      ),
    );
  }
}
