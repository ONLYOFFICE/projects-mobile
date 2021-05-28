import 'package:get/get.dart';

class AdaptiveSize {
  static double screenHeight = Get.height;
  static double screenWidth = Get.width;

  static const double designHeight = 812;
  static const double designWidth = 375;

  static double heightK = screenHeight / designHeight;
  static double widthK = screenWidth / designWidth;
}

double h(num height) => height * AdaptiveSize.heightK;
double w(num width) => width * AdaptiveSize.widthK;
