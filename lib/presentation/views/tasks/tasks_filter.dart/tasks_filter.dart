import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';

import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/filters/confirm_filters_button.dart';
import 'package:projects/presentation/shared/widgets/filters/filters_row.dart';
import 'package:projects/presentation/shared/widgets/filters/filter_element_widget.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/select_group_screen.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/select_milestone_screen.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/select_project_screen.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/select_tag_screen.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/users/select_user_screen.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_date_range_picker.dart';

part 'filters/responsible.dart';
part 'filters/creator.dart';
part 'filters/project.dart';
part 'filters/milestone.dart';
part 'filters/status.dart';
part 'filters/duedate.dart';

class TasksFilterScreen extends StatelessWidget {
  const TasksFilterScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BaseFilterController filterController =
        Get.arguments['filterController'];
    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor:
          platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
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
                      color: Get.theme.colors().systemBlue))),
          SizedBox(width: platformController.isMobile ? 8 : 12),
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
                  _Responsible(filterController: filterController),
                  _Creator(filterController: filterController),
                  _Project(filterController: filterController),
                  _Milestone(filterController: filterController),
                  _Status(filterController: filterController),
                  _DueDate(filterController: filterController),
                  const SizedBox(height: 60),
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
