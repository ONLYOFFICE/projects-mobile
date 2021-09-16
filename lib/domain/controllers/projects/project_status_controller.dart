import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_snackbar.dart';

class ProjectStatusesController extends GetxController {
  RxList statuses = <int>[0, 1, 2].obs;
  RxList statusImagesDecoded = <String>[].obs;
  RxBool loaded = false.obs;

  String getStatusName(int value) => ProjectStatus.toName(value);
  String getStatusImageString(int value) => ProjectStatus.toImageString(value);

  Future<bool> updateStatus({int newStatusId, projectData}) async {
    if (projectData.taskCount > 0 &&
        newStatusId == ProjectStatusCode.closed.index) {
      ScaffoldMessenger.of(Get.context).showSnackBar(styledSnackBar(
          context: Get.context,
          text: tr('cannotCloseProject'),
          buttonText: ''));
      return false;
    }

    var t = await locator<ProjectService>().updateProjectStatus(
        projectId: projectData.id,
        newStatus: ProjectStatus.toLiteral(newStatusId));

    if (t != null) {
      return true;
    }

    return false;
  }
}
