import 'package:projects/data/models/from_api/portal_user.dart';

class NameFormatter {
  static String formateName(PortalUser user) {
    if (user.firstName == null ||
        user.firstName.isEmpty ||
        user.lastName == null ||
        user.lastName.isEmpty) return user.displayName;

    return '${user.firstName.substring(0, 1)}. ${user.lastName}';
  }
}
