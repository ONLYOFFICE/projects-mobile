import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_editing_controller.dart';
import 'package:projects/domain/controllers/tasks/task_statuses_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/customBottomSheet.dart';
import 'package:projects/presentation/shared/widgets/status_tile.dart';
import 'package:projects/presentation/views/tasks/task_cell/task_cell.dart';

// here is a different function, because the task changes page has a
// slightly different algorithm than on the other pages: you do not need to
// update the status of the task immediately after clicking,
// but you need to do it when saving changes
Future<void> statusSelectionBS(
    {context, TaskEditingController controller}) async {
  var _statusesController = Get.find<TaskStatusesController>();

  showCustomBottomSheet(
    context: context,
    headerHeight: 60,
    initHeight:
        _getInititalSize(statusCount: _statusesController.statuses.length),
    decoration: BoxDecoration(
        color: Get.theme.colors().surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
    headerBuilder: (context, bottomSheetOffset) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18.5),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(tr('selectStatus'),
                style: TextStyleHelper.h6(color: Get.theme.colors().onSurface)),
          ),
          const SizedBox(height: 18.5),
        ],
      );
    },
    builder: (context, bottomSheetOffset) {
      return SliverChildListDelegate(
        [
          Obx(
            () => DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 1,
                      color: Get.theme.colors().outline.withOpacity(0.5)),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  for (var i = 0; i < _statusesController.statuses.length; i++)
                    InkWell(
                      onTap: () async {
                        await controller
                            .changeStatus(_statusesController.statuses[i]);
                        Get.back();
                      },
                      child: StatusTile(
                          title: _statusesController.statuses[i].title,
                          icon: StatusIcon(
                            canEditTask: true,
                            status: _statusesController.statuses[i],
                          ),
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

double _getInititalSize({int statusCount}) {
  var size = (statusCount * 75) / Get.height;
  return size > 0.7 ? 0.7 : size;
}
