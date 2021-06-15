import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DiscussionItemController extends GetxController {
  // final _api = locator<DiscussionItemService>();

  var discussion = Discussion().obs;
  var status = Status().obs;

  var loaded = true.obs;
  var refreshController = RefreshController();

  RxString statusImageString = ''.obs;
  // to show overview screen without loading
  RxBool firstReload = true.obs;

  DiscussionItemController(Discussion discussion) {
    this.discussion.value = discussion;
  }

  // Future reloadTask({bool showLoading = false}) async {
  //   if (showLoading) loaded.value = false;
  //   var t = await _api.getTaskByID(id: task.value.id);
  //   task.value = t;
  //   if (showLoading) loaded.value = true;
  // }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) {
      update();
    }
  }
}
