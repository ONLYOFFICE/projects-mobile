import 'package:get/get.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';

class NavigationController extends GetxController {
  var tabIndex = 0;
  var onMoreView = false;

  @override
  void onInit() {
    var portalController = Get.find<PortalInfoController>();
    if (portalController.portalName == null) portalController.onInit();
    super.onInit();
  }

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

  void clearCurrentIndex() => tabIndex = null;
}
