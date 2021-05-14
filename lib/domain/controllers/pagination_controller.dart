import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PaginationController extends GetxController {
  RxList data = [].obs;
  RefreshController refreshController = RefreshController();
  var startIndex = 0;
  var total = 0.obs;

  Function refreshDelegate;
  Function loadDelegate;

  var pullDownEnabled = false;
  bool get pullUpEnabled => data.length != total.value;

  void onRefresh() async {
    startIndex = 0;
    await refreshDelegate();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    startIndex += 25;
    if (startIndex >= total.value) {
      refreshController.loadComplete();
      startIndex -= 25;
      return;
    }
    await loadDelegate();
    refreshController.loadComplete();
  }

  void setup() {
    total.value = 0;
    startIndex = 0;
  }
}
