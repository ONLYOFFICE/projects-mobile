import 'package:flutter/material.dart';

class TextUtils {
  static double getTextWidth(String text, TextStyle style) {
    final tp = TextPainter(
      maxLines: 1,
      textAlign: TextAlign.left,
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return tp.width;
  }

  static Size getTextSize(String text, TextStyle style) {
    final textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
