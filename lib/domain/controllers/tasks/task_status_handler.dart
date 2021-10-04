import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/domain/controllers/tasks/task_statuses_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class TaskStatusHandler {
  TaskStatusHandler();

  final statusesController = Get.find<TaskStatusesController>();

  Color getBackgroundColor(Status status, bool canEdit) {
    if (status.isNull) throw Exception('STATUS IS NULL');
    if (!canEdit) return Get.theme.colors().onBackground.withOpacity(0.05);
    if (status.id < 0) return Get.theme.colors().primary.withOpacity(0.1);

    return Get.theme.colors().onBackground.withOpacity(0.05);
  }

  Color getTextColor(Status status, bool canEdit) {
    if (status.isNull) throw Exception('STATUS IS NULL');
    if (!canEdit) return Get.theme.colors().onSurface.withOpacity(0.75);
    if (status.id < 0) return Get.theme.colors().primary;

    return status?.color?.toColor() ?? Get.theme.colors().primary;
  }
}
