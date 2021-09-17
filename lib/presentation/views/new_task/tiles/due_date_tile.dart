import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/abstract_task_actions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/new_item_tile.dart';
import 'package:projects/presentation/views/new_task/select/select_date_view.dart';

class DueDateTile extends StatelessWidget {
  final TaskActionsController controller;
  const DueDateTile({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // ignore: omit_local_variable_types
        bool _isSelected = controller.dueDateText.value.isNotEmpty;
        return NewItemTile(
          icon: SvgIcons.due_date,
          text: _isSelected ? controller.dueDateText.value : tr('setDueDate'),
          caption: _isSelected ? '${tr('dueDate')}:' : null,
          isSelected: _isSelected,
          suffix: _isSelected
              ? IconButton(
                  icon: Icon(Icons.close_rounded,
                      size: 23,
                      color: Get.theme.colors().onSurface.withOpacity(0.6)),
                  onPressed: () => controller.changeDueDate(null))
              : null,
          suffixPadding: const EdgeInsets.only(right: 10),
          onTap: () => Get.find<NavigationController>().toScreen(
            const SelectDateView(),
            arguments: {
              'controller': controller,
              'startDate': false,
              'initialDate': controller.dueDate
            },
          ),
        );
      },
    );
  }
}
