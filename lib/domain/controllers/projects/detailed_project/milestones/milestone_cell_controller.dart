import 'package:get/get.dart';
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MilestoneCellController extends GetxController {
  var milestone = Milestone().obs;
  var status = Status().obs;

  var loaded = true.obs;
  var refreshController = RefreshController();

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
