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

class SvgIcons {

  SvgIcons._();
// I didn't add all the icons (!)
  static const String logo_new = 'lib/assets/images/logo_new.svg';

  static const String add_button = 'lib/assets/images/icons/add_button.svg';
  static const String check_round = 'lib/assets/images/icons/check_round.svg';
  static const String check_square = 'lib/assets/images/icons/check_square.svg';
  static const String high_priority = 'lib/assets/images/icons/high_priority.svg';
  static const String lock = 'lib/assets/images/icons/lock.svg';
  static const String preferences = 'lib/assets/images/icons/preferences.svg';
  static const String project_icon = 'lib/assets/images/icons/project_icon.svg';
  static const String search = 'lib/assets/images/icons/search.svg';
  static const String sorting_3_descend = 'lib/assets/images/icons/sorting_3_descend.svg';
  static const String subtasks = 'lib/assets/images/icons/subtasks.svg';
  static const String tasklist = 'lib/assets/images/icons/tasklist.svg';
  
  static const String due_date = 'lib/assets/images/icons/task_detailed/due_date.svg';
  static const String milestone = 'lib/assets/images/icons/task_detailed/milestone.svg';
  static const String person = 'lib/assets/images/icons/task_detailed/person.svg';
  static const String priority = 'lib/assets/images/icons/task_detailed/priority.svg';
  static const String project = 'lib/assets/images/icons/task_detailed/project.svg';
  static const String start_date = 'lib/assets/images/icons/task_detailed/project.svg';
  
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
    {
      @required this.icon,
      this.color,
      this.height,
      this.width,
      this.isPng = false
    }
  );

  @override
  Widget build(BuildContext context) {
    // Unfortunately, flutter svg does not support all svg files
    // Therefore, there will be support for png icons as well
    return isPng 

      ? Image(
        image: AssetImage(icon),
        color: color,
        height: height,
        width: width
      )

      : SvgPicture.asset(
        icon,
        color: color,
        height: height,
        width: width
      );
  }
}