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
import 'package:projects/presentation/shared/app_colors.dart';
import 'package:projects/presentation/shared/theme_service.dart';

extension ThemeDataExtensions on ThemeData {
  AppColors customColors() {
    if (ThemeService().isDark()) return darkColors;
    return lightColors;
  }
}

AppColors customTheme(BuildContext context) => Theme.of(context).customColors();

final AppColors lightColors = AppColors(
  activeTabTitle: Color(0xffffffff),
  background: Color(0xffFBFBFB),
  backgroundColor: Color(0xffffffff),
  bgDescription: Color(0xffF1F3F8),
  inactiveTabTitle: Color(0xffffffff).withOpacity(0.4),
  lightSecondary: Color(0xffED7309),
  links: Color(0xff0C76D5),
  onBackground: Color(0xff000000),
  onPrimary: Color(0xffffffff),
  onPrimarySurface: Color(0xffffffff),
  onSurface: Color(0xff000000),
  primary: Color(0xff0C76D5),
  primarySurface: Color(0xff0F4071),
  projectsSubtitle: Color(0xff000000).withOpacity(0.6),
  tabActive: Color.fromRGBO(255, 255, 255, 1),
  tabSecondary: Color.fromRGBO(255, 255, 255, 0.4),
  tabbarBackground: Color(0xff2E4057),
);

final AppColors darkColors = AppColors(
  backgroundColor: Color(0xff000000),
  activeTabTitle: Color(0xffffffff),
  inactiveTabTitle: Color(0xffffffff).withOpacity(0.4),
  tabbarBackground: Color(0xff2E4057),
  projectsSubtitle: Color(0xffffffff).withOpacity(0.6),
  background: Color(0xffFBFBFB),
  links: Color(0xff0C76D5),
  onSurface: Color(0xff000000),
  primarySurface: Color(0xff0F4071),
  primary: Color(0xff0C76D5)
);


final ThemeData lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  backgroundColor: Color(0xffffffff),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  backgroundColor: Color(0xff000000),
);