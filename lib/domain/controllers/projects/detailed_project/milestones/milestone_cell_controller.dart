import 'package:get/get.dart';
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/project_status.dart';

class MilestoneCellController extends GetxController {
  var milestone = Milestone().obs;
  var status = Status().obs;

  String get statusImage => ProjectStatus.toImageString(milestone.value.status);

  String get statusName => ProjectStatus.toName(milestone.value.status);

  MilestoneCellController(Milestone milestone) {
    this.milestone.value = milestone;
    initMilestoneStatus(milestone);
  }

  void initMilestoneStatus(Milestone task) {
    // var statusesController = Get.find<TaskStatusesController>();
    // status.value = statusesController.getTaskStatus(task);
    // statusImageString.value =
    //     statusesController.decodeImageString(status.value.image);
  }
}
