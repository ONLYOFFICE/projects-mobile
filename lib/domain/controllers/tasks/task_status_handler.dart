import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/domain/controllers/tasks/task_statuses_controller.dart';
import 'package:projects/internal/constants.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class TaskStatusHandler {
  TaskStatusHandler();

  final statusesController = Get.find<TaskStatusesController>();

  // ignore: unnecessary_cast
  Rx<Widget> statusImage = (const Center(
          child: SizedBox(
    width: 16,
    height: 16,
    child: Center(child: CircularProgressIndicator()),
  )) as Widget)
      .obs;

  void setStatusImage(Status status, bool canEdit) {
    if (!Const.standartTaskStatuses.containsKey(status.id)) {
      statusImage.value = _getCustomStatusIcon(status, canEdit);
    } else {
      statusImage.value = _getStandartStatusIcon(status, canEdit);
    }
  }

  Widget getStatusImage(Status status, bool canEdit) {
    if (!Const.standartTaskStatuses.containsKey(status.id))
      return _getCustomStatusIcon(status, canEdit);
    return _getStandartStatusIcon(status, canEdit);
  }

  Color getBackgroundColor(Status status, bool canEdit) {
    if (!canEdit) return Get.theme.colors().onBackground.withOpacity(0.05);
    if (status.id < 0) return Get.theme.colors().primary.withOpacity(0.1);

    return Get.theme.colors().onBackground.withOpacity(0.05);
  }

  Color getTextColor(Status status, bool canEdit) {
    if (status == null) return Colors.grey;
    if (!canEdit) return Get.theme.colors().onSurface.withOpacity(0.75);
    if (status.id < 0) return Get.theme.colors().primary;

    return status?.color?.toColor() ?? Get.theme.colors().primary;
  }

  Widget _getCustomStatusIcon(Status status, bool canEdit) {
    return Center(
        child: SVG.createSizedFromString(
            statusesController.decodeImageString(status?.image),
            16,
            16,
            canEdit
                ? status?.color?.toColor() ?? Get.theme.colors().primary
                : Get.theme.colors().onBackground.withOpacity(0.6)));
  }

  Widget _getStandartStatusIcon(Status status, bool canEdit) {
    return Center(
        child: AppIcon(
            icon: Const.standartTaskStatuses[status.id],
            color: canEdit
                ? Get.theme.colors().primary
                : Get.theme.colors().onBackground.withOpacity(0.6)));
  }
}
