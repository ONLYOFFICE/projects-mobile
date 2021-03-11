import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVG {
  static Widget create(String path) {
    return SvgPicture.asset(path, semanticsLabel: path);
  }
}
