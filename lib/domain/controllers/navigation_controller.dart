import 'package:get/get.dart';

class NavigationController extends GetxController {
  var tabIndex = 0;
  var onMoreView = false;

  void changeTabIndex(int index) {
    if (index < 3) {
      onMoreView = false;
      tabIndex = index;
      update();
    } else {
      if (index == 3) {
        if (!onMoreView) {
          onMoreView = true;
          update();
        } else {
          onMoreView = false;
          update();
        }
      } else {
        onMoreView = false;
        tabIndex = index;
        update();
      }
    }
  }
}
