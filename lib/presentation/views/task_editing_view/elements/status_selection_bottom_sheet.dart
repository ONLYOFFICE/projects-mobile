import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_editing_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/task_status_bottom_sheet.dart';

// here is a different function, because the task changes page has a
// slightly different algorithm than on the other pages: you do not need to
// update the status of the task immediately after clicking,
// but you need to do it when saving changes
void statusSelectionBS({context, TaskEditingController controller}) async {
  await showStickyFlexibleBottomSheet(
    context: context,
    headerHeight: 60,
    // isExpand: true,
    initHeight: 0.6,
    decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
    headerBuilder: (context, bottomSheetOffset) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18.5),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text('Select status',
                style: TextStyleHelper.h6(
                    color: Theme.of(context).customColors().onSurface)),
          ),
          const SizedBox(height: 18.5),
        ],
      );
    },
    builder: (context, bottomSheetOffset) {
      var _statusesController = Get.find<TaskStatusesController>();
      return SliverChildListDelegate(
        [
          Obx(
            () => DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 1,
                      color: Theme.of(context)
                          .customColors()
                          .outline
                          .withOpacity(0.5)),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  for (var i = 0; i < _statusesController.statuses.length; i++)
                    InkWell(
                      onTap: () async {
                        controller
                            .changeStatus(_statusesController.statuses[i]);
                        Get.back();
                      },
                      child: StatusTile(
                          title: _statusesController.statuses[i].title,
                          icon: SVG.createSizedFromString(
                              _statusesController.statusImagesDecoded[i],
                              16,
                              16),
                          selected: _statusesController.statuses[i].id ==
                              controller.newStatus.value.id),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}