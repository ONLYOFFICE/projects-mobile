import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/services/discussion_item_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DiscussionItemController extends GetxController {
  final _api = locator<DiscussionItemService>();

  var discussion = Discussion().obs;

  var loaded = true.obs;
  var refreshController = RefreshController();

  RxString statusImageString = ''.obs;
  // to show overview screen without loading
  RxBool firstReload = true.obs;

  DiscussionItemController(Discussion discussion) {
    this.discussion.value = discussion;
  }

  void onRefresh() async => await getDiscussionDetailed();

  Future<void> getDiscussionDetailed({bool showLoading = true}) async {
    if (showLoading) loaded.value = false;
    var result = await _api.getMessageDetailed(id: discussion.value.id);
    if (result != null) discussion.value = result;
    if (showLoading) loaded.value = true;
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) {
      update();
    }
  }
}
