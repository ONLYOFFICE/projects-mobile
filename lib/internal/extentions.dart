import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

extension CustomList<T> on List<T> {
  static T firstOrNull<T>(List<T> list) {
    if (list.isEmpty) {
      return null;
    } else {
      return list.first;
    }
  }
}

// TODO: форматированная дата
String formatedDate({DateTime now, String stringDate}) {
  var date = DateTime.parse(stringDate);

  if (now.year == date.year) {
    final formatter = DateFormat('d MMM');
    return formatter.format(date);
  } else {
    final formatter = DateFormat('d MMM yyy');
    return formatter.format(date);
  }
}

extension ColorExtension on String {
  Color toColor() {
    // ignore: unnecessary_this
    var hexColor = this.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse('0x$hexColor'));
    } else {
      return const Color(0xffffffff);
    }
  }
}
