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

import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppColors {
  final Color background;
  final Color backgroundColor;
  final Color bgDescription;

  final Color lightSecondary;
  final Color links;
  final Color onBackground;
  final Color onNavBar;
  final Color onPrimary;
  final Color onPrimarySurface;
  final Color onSurface;
  final Color outline;
  final Color primary;
  final Color primarySurface;
  final Color projectsSubtitle;
  final Color snackBarColor;
  final Color systemBlue;
  final Color surface;
  final Color tabbarBackground;
  final Color colorError;
  final Color backgroundSecond;
  final Color inactiveGrey;
  final Color skeleton;
  final Color skeletonHighlighted;

  const AppColors({
    required this.background,
    required this.backgroundColor,
    required this.bgDescription,
    required this.lightSecondary,
    required this.links,
    required this.onBackground,
    required this.onNavBar,
    required this.onPrimary,
    required this.onPrimarySurface,
    required this.onSurface,
    required this.outline,
    required this.primary,
    required this.primarySurface,
    required this.projectsSubtitle,
    required this.snackBarColor,
    required this.systemBlue,
    required this.surface,
    required this.tabbarBackground,
    required this.colorError,
    required this.backgroundSecond,
    required this.inactiveGrey,
    required this.skeleton,
    required this.skeletonHighlighted,
  });
}
