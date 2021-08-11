import 'package:get/get.dart';
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

String formatedDateFromString({DateTime now, String stringDate}) {
  var date = DateTime.parse(stringDate);

  if (now.year == date.year) {
    // final formatter = DateFormat('d MMM');
    final formatter = DateFormat.MMMMd(Get.locale.languageCode);
    return formatter.format(date);
  } else {
    final formatter = DateFormat.yMMMMd(Get.locale.languageCode);
    // final formatter = DateFormat('d MMM yyy');
    return formatter.format(date);
  }
}

String formatedDate(DateTime date, {DateTime now}) {
  now ??= DateTime.now();

  if (now.year == date.year) {
    final formatter = DateFormat.MMMMd(Get.locale.languageCode);
    // final formatter = DateFormat('d MMM');
    return formatter.format(date);
  } else {
    final formatter = DateFormat.yMMMMd(Get.locale.languageCode);
    // final formatter = DateFormat('d MMM yyy');
    return formatter.format(date);
  }
}

extension ColorExtension on String {
  Color toColor() {
    // ignore: unnecessary_this
    var hexColor = this.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    if (hexColor.length == 8) {
      return Color(int.parse('0x$hexColor'));
    } else {
      return const Color(0xff000000);
    }
  }
}
