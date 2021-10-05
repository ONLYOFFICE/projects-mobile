import 'package:projects/data/models/from_api/portal_user.dart';

class NameFormatter {
  static String formateName(PortalUser user) {
    if (user.firstName == null || user.firstName.isEmpty) {
      if (user.lastName == null || user.lastName.isEmpty)
        return user.displayName;
      return user.lastName;
    }

    return '${user.firstName.substring(0, 1)}. ${user.lastName}';
  }

  static String formateDisplayName(String displayName) {
    var splited = displayName.split(' ');
    if (splited.length != 2) return displayName;
    return '${splited[1][0]}. ${splited[0]}';
  }
}
