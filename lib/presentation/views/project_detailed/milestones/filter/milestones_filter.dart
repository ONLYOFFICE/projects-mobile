import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';

import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_filter_controller.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/filters/confirm_filters_button.dart';
import 'package:projects/presentation/shared/widgets/filters/filters_row.dart';
import 'package:projects/presentation/shared/widgets/filters/filter_element_widget.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/users/select_user_screen.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_date_range_picker.dart';

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
        titleText: tr('filter'),
        showBackButton: true,
        backButtonIcon: Get.put(PlatformController()).isMobile
            ? const Icon(Icons.arrow_back_rounded)
            : const Icon(Icons.close),
        actions: [
          TextButton(
              onPressed: () async => filterController.resetFilters(),
              child: Text(tr('reset'),
                  style: TextStyleHelper.button(
                      color: Get.theme.colors().systemBlue)))
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
