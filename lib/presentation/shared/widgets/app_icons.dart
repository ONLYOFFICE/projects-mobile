import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcons {
  SvgIcons._();
// I didn't add all the icons (!)
  static const String logo_new = 'lib/assets/images/logo_new.svg';

  static const String add_button = 'lib/assets/images/icons/add_button.svg';
  static const String check_round = 'lib/assets/images/icons/check_round.svg';
  static const String check_square = 'lib/assets/images/icons/check_square.svg';
  static const String high_priority =
      'lib/assets/images/icons/high_priority.svg';
  static const String lock = 'lib/assets/images/icons/lock.svg';
  static const String preferences = 'lib/assets/images/icons/preferences.svg';
  static const String project_icon = 'lib/assets/images/icons/project_icon.svg';
  static const String back_round = 'lib/assets/images/icons/back_round.svg';

  static const String search = 'lib/assets/images/icons/search.svg';
  static const String sorting_3_descend =
      'lib/assets/images/icons/sorting_3_descend.svg';
  static const String subtasks = 'lib/assets/images/icons/subtasks.svg';
  static const String tasklist = 'lib/assets/images/icons/tasklist.svg';

  static const String due_date =
      'lib/assets/images/icons/task_detailed/due_date.svg';
  static const String milestone =
      'lib/assets/images/icons/task_detailed/milestone.svg';
  static const String person =
      'lib/assets/images/icons/task_detailed/person.svg';
  static const String priority =
      'lib/assets/images/icons/task_detailed/priority.svg';
  static const String project =
      'lib/assets/images/icons/task_detailed/project.svg';
  static const String start_date =
      'lib/assets/images/icons/task_detailed/start_date.svg';

  static const String open =
      'lib/assets/images/icons/project_statuses/open.svg';
  static const String closed =
      'lib/assets/images/icons/project_statuses/closed.svg';
  static const String paused =
      'lib/assets/images/icons/project_statuses/paused.svg';

  static const String user = 'lib/assets/images/icons/user.svg';
  static const String users = 'lib/assets/images/icons/users.svg';
}

class PngIcons {
  PngIcons._();
}

// TODO: icons. Delete todo as you see it
class AppIcon extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final String icon;
  final bool isPng;

  AppIcon(
      {@required this.icon,
      this.color,
      this.height,
      this.width,
      this.isPng = false});

  @override
  Widget build(BuildContext context) {
    // Unfortunately, flutter svg does not support all svg files
    // Therefore, there will be support for png icons as well
    return isPng
        ? Image(
            image: AssetImage(icon), color: color, height: height, width: width)
        : SvgPicture.asset(icon, color: color, height: height, width: width);
  }
}
