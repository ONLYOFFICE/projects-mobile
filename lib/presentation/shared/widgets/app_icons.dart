/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SvgIcons {
  SvgIcons._();

  static const String app_logo = 'lib/assets/images/app_logo.svg';
  static const String title = 'lib/assets/images/icons/title.svg';

  static const String tab_bar_dashboard =
      'lib/assets/images/icons/tab_bar/dashboard.svg';
  static const String tab_bar_tasks =
      'lib/assets/images/icons/tab_bar/tasks.svg';
  static const String tab_bar_projects =
      'lib/assets/images/icons/tab_bar/projects.svg';
  static const String tab_bar_more = 'lib/assets/images/icons/tab_bar/more.svg';

  static const String add_button = 'lib/assets/images/icons/add_button.svg';
  static const String add_fab = 'lib/assets/images/icons/add_fab.svg';
  static const String add_discussion =
      'lib/assets/images/icons/add_discussion.svg';
  static const String back_round = 'lib/assets/images/icons/back_round.svg';
  static const String check_round = 'lib/assets/images/icons/check_round.svg';
  static const String check_square = 'lib/assets/images/icons/check_square.svg';
  static const String cloud = 'lib/assets/images/icons/cloud.svg';
  static const String comments = 'lib/assets/images/icons/comments.svg';
  static const String copy = 'lib/assets/images/icons/copy.svg';
  static const String delete_number =
      'lib/assets/images/icons/delete_number.svg';
  static const String discussions = 'lib/assets/images/icons/discussions.svg';
  static const String documents = 'lib/assets/images/icons/documents.svg';
  static const String down_arrow = 'lib/assets/images/icons/down_arrow.svg';
  static const String finger_print = 'lib/assets/images/icons/finger_print.svg';
  static const String high_priority =
      'lib/assets/images/icons/high_priority.svg';
  static const String lock = 'lib/assets/images/icons/lock.svg';
  static const String logout = 'lib/assets/images/icons/logout.svg';
  static const String message = 'lib/assets/images/icons/message.svg';
  static const String password_recovery =
      'lib/assets/images/icons/password_recovery.svg';
  static const String preferences = 'lib/assets/images/icons/preferences.svg';
  static const String preferences_active =
      'lib/assets/images/icons/preferences_active.svg';
  static const String preferences_active_dark_theme =
      'lib/assets/images/icons/preferences_active_dark_theme.svg';
  static const String project_icon = 'lib/assets/images/icons/project_icon.svg';
  static const String subscribers = 'lib/assets/images/icons/subscribers.svg';

  static const String search = 'lib/assets/images/icons/search.svg';
  static const String settings = 'lib/assets/images/icons/settings.svg';
  static const String sorting_3_descend =
      'lib/assets/images/icons/sorting_3_descend.svg';
  static const String subtasks = 'lib/assets/images/icons/subtasks.svg';
  static const String tasklist = 'lib/assets/images/icons/tasklist.svg';
  static const String up_arrow = 'lib/assets/images/icons/up_arrow.svg';

  // settings
  static const String about_app = 'lib/assets/images/icons/about_app.svg';
  static const String analytics = 'lib/assets/images/icons/analytics.svg';
  static const String clean = 'lib/assets/images/icons/clean.svg';
  static const String color_scheme = 'lib/assets/images/icons/color_scheme.svg';
  static const String help = 'lib/assets/images/icons/help.svg';
  static const String passcode = 'lib/assets/images/icons/passcode.svg';
  static const String rate_app = 'lib/assets/images/icons/rate_app.svg';
  static const String support = 'lib/assets/images/icons/support.svg';
  static const String feedback = 'lib/assets/images/icons/feedback.svg';
  static const String terms_of_service =
      'lib/assets/images/icons/terms_of_service.svg';
  static const String privacy_policy =
      'lib/assets/images/icons/privacy_policy.svg';
  static const String version = 'lib/assets/images/icons/version.svg';

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

  static const String projectOpen =
      'lib/assets/images/icons/project_statuses/open.svg';
  static const String projectClosed =
      'lib/assets/images/icons/project_statuses/closed.svg';
  static const String projectPaused =
      'lib/assets/images/icons/project_statuses/paused.svg';

  static const String taskOpen =
      'lib/assets/images/icons/task_statuses/open_light.svg';
  static const String taskClosed =
      'lib/assets/images/icons/task_statuses/closed_light.svg';
  static const String taskPaused =
      'lib/assets/images/icons/task_statuses/paused_light.svg';

  static const String user = 'lib/assets/images/icons/user.svg';
  static const String users = 'lib/assets/images/icons/users.svg';
  static const String avatar = 'lib/assets/images/icons/avatar.svg';
  static const String fab_project = 'lib/assets/images/icons/fab_project.svg';
  static const String fab_milestone =
      'lib/assets/images/icons/fab_milestone.svg';
  static const String sorting_4_ascend =
      'lib/assets/images/icons/sorting_4_ascend.svg';
  static const String description = 'lib/assets/images/icons/description.svg';
  static const String calendar = 'lib/assets/images/icons/calendar.svg';
  static const String tag = 'lib/assets/images/icons/tag.svg';
  static const String atribute = 'lib/assets/images/icons/atribute.svg';

  static const String folder = 'lib/assets/images/icons/folders/folder.svg';
  static const String doc = 'lib/assets/images/icons/folders/doc.svg';
  static const String image = 'lib/assets/images/icons/folders/image.svg';
  static const String table = 'lib/assets/images/icons/folders/table.svg';
  static const String archive = 'lib/assets/images/icons/folders/archive.svg';
  static const String presentation =
      'lib/assets/images/icons/folders/presentation.svg';

  static const String comments_not_created =
      'lib/assets/images/icons/empty_state/comments_not_created.svg';
  static const String comments_not_created_dark =
      'lib/assets/images/icons/empty_state/comments_not_created_dark.svg';
  static const String documents_not_created =
      'lib/assets/images/icons/empty_state/documents_not_created.svg';
  static const String documents_not_created_dark =
      'lib/assets/images/icons/empty_state/documents_not_created_dark.svg';
  static const String milestone_not_created =
      'lib/assets/images/icons/empty_state/milestone_not_created.svg';
  static const String milestone_not_created_dark =
      'lib/assets/images/icons/empty_state/milestone_not_created_dark.svg';
  static const String task_not_created =
      'lib/assets/images/icons/empty_state/task_not_created.svg';
  static const String task_not_created_dark =
      'lib/assets/images/icons/empty_state/task_not_created_dark.svg';
  static const String project_not_created =
      'lib/assets/images/icons/empty_state/project_not_created.svg';
  static const String project_not_created_dark =
      'lib/assets/images/icons/empty_state/project_not_created_dark.svg';
  static const String not_found =
      'lib/assets/images/icons/empty_state/not_found.svg';
  static const String not_found_dark =
      'lib/assets/images/icons/empty_state/not_found_dark.svg';

  static const String fab_user = 'lib/assets/images/icons/fab_user.svg';
  static const String group = 'lib/assets/images/icons/group.svg';

  static const String no_internet =
      'lib/assets/images/icons/empty_state/no_internet.svg';
  static const String no_internet_dark =
      'lib/assets/images/icons/empty_state/no_internet_dark.svg';

  static const String userBlocked =
      'lib/assets/images/icons/user_atributes/blocked.svg';
  static const String userAdmin =
      'lib/assets/images/icons/user_atributes/admin.svg';
  static const String userVisitor =
      'lib/assets/images/icons/user_atributes/visitor.svg';
}

class PngIcons {
  PngIcons._();
  static const String authentificator_s2 =
      'lib/assets/images/images/authentificator_s2.png';
  static const String authentificator_s2_dark =
      'lib/assets/images/images/authentificator_s2_dark.png';
  static const String authentificator_s3 =
      'lib/assets/images/images/authentificator_s3.png';
  static const String authentificator_s3_dark =
      'lib/assets/images/images/authentificator_s3_dark.png';
  static const String code_light = 'lib/assets/images/images/code_light.png';
  static const String code_dark = 'lib/assets/images/images/code_dark.png';
  static const String download_GA = 'lib/assets/images/images/download_GA.png';
  static const String download_GA_dark =
      'lib/assets/images/images/download_GA_dark.png';

  static const String splash = 'lib/assets/splash/splash-light.png';
  static const String splash_dark = 'lib/assets/splash/splash-dark.png';
}

class AppIcon extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final String icon;
  final String darkThemeIcon;
  final bool isPng;
  final bool hasDarkVersion;

  AppIcon({
    Key key,
    @required this.icon,
    this.color,
    this.height,
    this.width,
    this.isPng = false,
    this.hasDarkVersion = false,
    this.darkThemeIcon,
  }) : super(key: key);

  String get iconToDisplay {
    if (!hasDarkVersion) return icon;

    if (Get.theme.brightness == Brightness.dark)
      return darkThemeIcon ?? icon.replaceFirst('.', '_dark.');
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    // Unfortunately, flutter svg does not support all svg files
    // Therefore, there will be support for png icons as well
    return isPng
        ? Image(
            image: AssetImage(iconToDisplay),
            color: color,
            height: height,
            width: width,
          )
        : SvgPicture.asset(
            iconToDisplay,
            color: color,
            height: height,
            width: width,
          );
  }
}
