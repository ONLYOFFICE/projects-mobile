import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_handler.dart';
import 'package:projects/domain/controllers/tasks/task_statuses_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/customBottomSheet.dart';
import 'package:projects/presentation/shared/widgets/status_tile.dart';

void showsStatusesBS({context, TaskItemController taskItemController}) async {
  var _statusesController = Get.find<TaskStatusesController>();
  var statusHandler = TaskStatusHandler();
  showCustomBottomSheet(
    context: context,
    headerHeight: 60,
    initHeight:
        _getInititalSize(statusCount: _statusesController.statuses.length),
    // maxHeight: 0.7,
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
                        await taskItemController.updateTaskStatus(
                            id: taskItemController.task.value.id,
                            newStatusId: _statusesController.statuses[i].id,
                            newStatusType:
                                _statusesController.statuses[i].statusType);
                        Get.back();
                      },
                      child: StatusTile(
                          title: _statusesController.statuses[i].title,
                          icon: statusHandler.getStatusImage(
                              _statusesController.statuses[i], true),
                          selected: _statusesController.statuses[i].title ==
                              taskItemController.status.value.title),
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
  var size = ((statusCount * 75) + 16) / Get.height;
  return size > 0.7 ? 0.7 : size;
}
