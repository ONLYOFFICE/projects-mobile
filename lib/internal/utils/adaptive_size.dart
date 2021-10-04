import 'package:get/get.dart';

class AdaptiveSize {
  static const double designHeight = 812;
  static const double designWidth = 375;

  static double screenHeight = Get.height;
  static double screenWidth = Get.width;

  static double get heightK => screenHeight / designHeight;
  static double get widthK => screenWidth / designWidth;

  static void updateScreenSize({double height, double width}) {
    screenHeight = height ?? Get.height;
    screenWidth = width ?? Get.width;
  }
}

double h(num height) => height * AdaptiveSize.heightK;
double w(num width) => width * AdaptiveSize.widthK;

extension Adaptive on num {
  num get h => this * AdaptiveSize.heightK;
  num get w => this * AdaptiveSize.widthK;
}
