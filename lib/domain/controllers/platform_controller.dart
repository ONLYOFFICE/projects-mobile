import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PlatformController extends GetxController {
  bool get isMobile => isMobilePlatform();

  bool isMobilePlatform() {
    // The equivalent of the "smallestWidth" qualifier on Android.
    var shortestSide = MediaQuery.of(Get.context).size.shortestSide;

    // Determine if we should use mobile layout or not, 600 here is
    // a common breakpoint for a typical 7-inch tablet.
    return shortestSide < 600;
  }
}
