import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVG {
  static Widget create(String path) {
    return SvgPicture.asset(
      path,
      semanticsLabel: path,
    );
  }

  static Widget createSized(String path, double width, double height) {
    return SvgPicture.asset(
      path,
      semanticsLabel: path,
      width: width,
      height: height,
    );
  }

  static Widget createSizedFromString(
      String imageString, double width, double height,
      [String color]) {
    return SvgPicture.string(
      imageString,
      width: width,
      height: height,
    );
  }
}
