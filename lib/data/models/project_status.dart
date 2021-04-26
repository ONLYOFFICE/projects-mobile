import 'package:projects/presentation/shared/widgets/app_icons.dart';

class ProjectStatus {
  static String toName(int status) {
    switch (status) {
      case 0:
        return 'Open';
        break;
      case 1:
        return 'Closed';
        break;
      case 2:
        return 'Paused';
        break;
      default:
        return 'n/a';
    }
  }

  static String toImageString(int status) {
    switch (status) {
      case 0:
        return SvgIcons.open;
        break;
      case 1:
        return SvgIcons.closed;
        break;
      case 2:
        return SvgIcons.paused;
        break;
      default:
        return 'n/a';
    }
  }
}
