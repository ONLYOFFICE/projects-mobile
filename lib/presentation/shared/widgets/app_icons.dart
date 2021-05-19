import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcons {
  SvgIcons._();
  static const String logo_new = 'lib/assets/images/logo_new.svg';

  static const String tab_bar_dashboard =
      'lib/assets/images/icons/tab_bar/dashboard.svg';
  static const String tab_bar_dashboard_active =
      'lib/assets/images/icons/tab_bar/dashboard_active.svg';
  static const String tab_bar_tasks =
      'lib/assets/images/icons/tab_bar/tasks.svg';
  static const String tab_bar_tasks_active =
      'lib/assets/images/icons/tab_bar/tasks_active.svg';
  static const String tab_bar_projects =
      'lib/assets/images/icons/tab_bar/projects.svg';
  static const String tab_bar_projects_active =
      'lib/assets/images/icons/tab_bar/projects_active.svg';
  static const String tab_bar_more = 'lib/assets/images/icons/tab_bar/more.svg';
  static const String tab_bar_more_active =
      'lib/assets/images/icons/tab_bar/more_active.svg';

  static const String add_button = 'lib/assets/images/icons/add_button.svg';
  static const String check_round = 'lib/assets/images/icons/check_round.svg';
  static const String check_square = 'lib/assets/images/icons/check_square.svg';
  static const String cloud = 'lib/assets/images/icons/cloud.svg';
  static const String discussions = 'lib/assets/images/icons/discussions.svg';
  static const String documents = 'lib/assets/images/icons/documents.svg';
  static const String down_arrow = 'lib/assets/images/icons/down_arrow.svg';
  static const String high_priority =
      'lib/assets/images/icons/high_priority.svg';
  static const String lock = 'lib/assets/images/icons/lock.svg';
  static const String logout = 'lib/assets/images/icons/logout.svg';
  static const String message = 'lib/assets/images/icons/message.svg';
  static const String preferences = 'lib/assets/images/icons/preferences.svg';
  static const String project_icon = 'lib/assets/images/icons/project_icon.svg';
  static const String back_round = 'lib/assets/images/icons/back_round.svg';

  static const String search = 'lib/assets/images/icons/search.svg';
  static const String settings = 'lib/assets/images/icons/settings.svg';
  static const String sorting_3_descend =
      'lib/assets/images/icons/sorting_3_descend.svg';
  static const String subtasks = 'lib/assets/images/icons/subtasks.svg';
  static const String tasklist = 'lib/assets/images/icons/tasklist.svg';
  static const String up_arrow = 'lib/assets/images/icons/up_arrow.svg';

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
  static const String avatar = 'lib/assets/images/icons/avatar.svg';
  static const String add_project = 'lib/assets/images/icons/add_project.svg';
  static const String add_milestone =
      'lib/assets/images/icons/add_milestone.svg';
  static const String sorting_4_ascend =
      'lib/assets/images/icons/sorting_4_ascend.svg';
  static const String description = 'lib/assets/images/icons/description.svg';
  static const String calendar = 'lib/assets/images/icons/calendar.svg';
  static const String tag = 'lib/assets/images/icons/tag.svg';
  static const String atribute = 'lib/assets/images/icons/atribute.svg';
}

class PngIcons {
  PngIcons._();
}

class AppIcon extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final String icon;
  final bool isPng;

  AppIcon(
      {Key key,
      @required this.icon,
      this.color,
      this.height,
      this.width,
      this.isPng = false})
      : super(key: key);

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
