import 'package:easy_localization/easy_localization.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

enum ProjectStatusCode { open, closed, paused }

class ProjectStatus {
  static String toName(int status) {
    switch (status) {
      case 0:
        return tr('open');
        break;
      case 1:
        return tr('closed');
        break;
      case 2:
        return tr('paused');
        break;
      default:
        return 'n/a';
    }
  }

  static String toLiteral(int status) {
    switch (status) {
      case 0:
        return 'open';
        break;
      case 1:
        return 'closed';
        break;
      case 2:
        return 'paused';
        break;
      default:
        return 'n/a';
    }
  }

  static String toImageString(int status) {
    switch (status) {
      case 0:
        return SvgIcons.projectOpen;
        break;
      case 1:
        return SvgIcons.projectClosed;
        break;
      case 2:
        return SvgIcons.projectPaused;
        break;
      default:
        return 'n/a';
    }
  }
}
