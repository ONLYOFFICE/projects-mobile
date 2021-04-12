import 'package:intl/intl.dart';

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
