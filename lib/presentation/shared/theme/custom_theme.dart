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
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/app_colors.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

extension ThemeDataExtensions on ThemeData {
  AppColors colors() {
    if (Get.isDarkMode) {
      return darkColors;
    }
    return lightColors;
  }
}

final AppColors lightColors = AppColors(
  background: const Color(0xffFBFBFB),
  backgroundColor: const Color(0xffffffff),
  bgDescription: const Color(0xffF1F3F8),
  colorError: const Color(0xffFF0C3E),
  lightSecondary: const Color(0xffED7309),
  links: const Color(0xff0C76D5),
  onBackground: const Color(0xff000000),
  onNavBar: const Color(0xffffffff),
  onPrimary: const Color(0xffffffff),
  onPrimarySurface: const Color(0xffffffff),
  onSurface: const Color(0xff000000),
  outline: const Color(0xffD8D8D8),
  primary: const Color(0xff1A73E9),
  primarySurface: const Color(0xff0F4071),
  projectsSubtitle: const Color(0xff000000).withOpacity(0.6),
  snackBarColor: const Color(0xff333333),
  surface: const Color(0xffffffff),
  systemBlue: const Color(0xff007aff),
  tabbarBackground: const Color(0xff2E4057),
);

final AppColors darkColors = AppColors(
  background: const Color(0xff121212),
  backgroundColor: const Color(0xff121212),
  bgDescription: const Color(0xff363636),
  colorError: const Color(0xffFF5679),
  lightSecondary: const Color(0xffFFAF49),
  links: const Color(0xff0C76D5),
  onBackground: const Color(0xffffffff),
  onNavBar: const Color(0xffFFFFFF),
  onPrimary: const Color(0xffffffff),
  onPrimarySurface: const Color(0xff000000),
  onSurface: const Color.fromRGBO(255, 255, 255, 0.87),
  outline: const Color(0xff3F3F3F),
  primary: const Color(0xff3E9CF0),
  primarySurface: const Color(0xff191919),
  projectsSubtitle: const Color(0xffffffff).withOpacity(0.6),
  snackBarColor: const Color(0xff333333),
  surface: const Color(0xff252525),
  systemBlue: const Color(0xff007aff),
  tabbarBackground: const Color(0xff2E4057),
);

final ThemeData lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  backgroundColor: lightColors.backgroundColor,
  scaffoldBackgroundColor: lightColors.backgroundColor,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: lightColors.primary),
    backgroundColor: lightColors.backgroundColor,
    titleTextStyle: TextStyleHelper.headline6(color: Colors.black),
    // lightColors.onSurface),
    // text
  ),
  navigationRailTheme:
      NavigationRailThemeData(backgroundColor: lightColors.primarySurface),
  popupMenuTheme: PopupMenuThemeData(
    textStyle: TextStyleHelper.subtitle1(color: lightColors.onSurface),
    elevation: 10,
  ),
  dialogTheme: DialogTheme(
      titleTextStyle: TextStyleHelper.subtitle1(color: lightColors.onSurface),
      contentTextStyle:
          TextStyleHelper.body2(color: lightColors.onSurface.withOpacity(0.6))),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  backgroundColor: darkColors.backgroundColor,
  scaffoldBackgroundColor: darkColors.backgroundColor,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: darkColors.primary),
    backgroundColor: darkColors.backgroundColor,
    titleTextStyle: TextStyleHelper.headline6(color: Colors.black),
  ),
  navigationRailTheme:
      NavigationRailThemeData(backgroundColor: darkColors.primarySurface),
  popupMenuTheme: PopupMenuThemeData(
    textStyle: TextStyleHelper.subtitle1(color: darkColors.onSurface),
    elevation: 10,
  ),
  dialogTheme: DialogTheme(
      titleTextStyle: TextStyleHelper.subtitle1(color: darkColors.onSurface),
      contentTextStyle:
          TextStyleHelper.body2(color: darkColors.onSurface.withOpacity(0.6))),
);
