import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/groups_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/milestone_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/projects_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/tags_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/users_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/filters/confirm_filters_button.dart';
import 'package:projects/presentation/shared/widgets/filters/filters_row.dart';
import 'package:projects/presentation/shared/widgets/filters/filter_element_widget.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

part 'filters/responsible.dart';
part 'filters/creator.dart';
part 'filters/project.dart';
part 'filters/milestone.dart';
part 'filters/duedate.dart';

class TasksFilterScreen extends StatelessWidget {
  const TasksFilterScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();

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
                  const _Responsible(),
                  const _Creator(),
                  const _Project(),
                  const _Milestone(),
                  const _DueDate(),
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
