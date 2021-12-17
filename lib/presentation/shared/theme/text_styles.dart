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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class TextStyleHelper {
  static final body1 = Platform.isAndroid ? _android_body1 : _ios_body1;
  static const _android_body1 = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.5,
      letterSpacing: 0.44);
  static const _ios_body1 =
      TextStyle(fontFamily: '.SF UI Text', fontWeight: FontWeight.w400, fontSize: 16, height: 1.5);

  static TextStyle body2({Color? color}) =>
      Platform.isAndroid ? _androidBody2(color: color) : _iosBody2(color: color);

  static TextStyle _androidBody2({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.429,
        letterSpacing: 0.25,
        color: color);
  }

  static TextStyle _iosBody2({Color? color}) {
    return TextStyle(
        fontFamily: '.SF UI Text',
        fontWeight: FontWeight.w400,
        fontSize: 15,
        height: 1.333,
        color: color);
  }

  static TextStyle button({Color? color}) =>
      Platform.isAndroid ? _androidButton(color: color) : _iosButton(color: color);

  static TextStyle _androidButton({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.714,
        letterSpacing: 1.5,
        color: color);
  }

  static TextStyle _iosButton({Color? color}) {
    return TextStyle(fontFamily: '.SF UI Text', fontSize: 17, height: 1.411, color: color);
  }

  static TextStyle caption({Color? color}) =>
      Platform.isAndroid ? _androidCaption(color: color) : _iosCaption(color: color);

  static TextStyle _androidCaption({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w400,
        color: color);
  }

  static TextStyle _iosCaption({Color? color}) {
    return TextStyle(fontFamily: '.SF UI Display', fontSize: 12, height: 1.333, color: color);
  }

  static final mainStyle = Platform.isAndroid ? _android_mainStyle : _ios_mainStyle;
  static const _android_mainStyle = TextStyle(fontFamily: 'Roboto', fontSize: 20);
  static const _ios_mainStyle = TextStyle(fontFamily: '.SF UI Text', fontSize: 20);

  static TextStyle h6({Color? color}) =>
      Platform.isAndroid ? _androidH6(color: color) : _iosH6(color: color);

  static TextStyle _androidH6({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        height: 1.172,
        letterSpacing: 0.15,
        color: color);
  }

  // TODO: сheck style for ios
  static TextStyle _iosH6({Color? color}) {
    return TextStyle(
        fontFamily: '.SF UI Text',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        height: 1.172,
        letterSpacing: 0.15,
        color: color);
  }

  static TextStyle headline3({Color? color}) =>
      Platform.isAndroid ? _androidHeadline3(color: color) : _iosHeadline3(color: color);

  static TextStyle _androidHeadline3({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 48,
        height: 1.333,
        color: color);
  }

  static TextStyle _iosHeadline3({Color? color}) {
    return TextStyle(
        fontFamily: '.SF UI Text',
        fontWeight: FontWeight.w400,
        fontSize: 48,
        height: 1.333,
        color: color);
  }

  static TextStyle headline4({Color? color}) =>
      Platform.isAndroid ? _androidHeadline4(color: color) : _iosHeadline4(color: color);

  static TextStyle _androidHeadline4({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 34,
        height: 40 / 34,
        letterSpacing: 0.25,
        color: color);
  }

  static TextStyle _iosHeadline4({Color? color}) {
    return TextStyle(
        fontFamily: '.SF UI Text',
        fontWeight: FontWeight.w400,
        fontSize: 34,
        height: 40 / 34,
        letterSpacing: 0.25,
        color: color);
  }

  static TextStyle headline5({Color? color}) =>
      Platform.isAndroid ? _androidHeadline5(color: color) : _iosHeadline5(color: color);

  static TextStyle _androidHeadline5({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 24,
        height: 1.333,
        color: color);
  }

  static TextStyle _iosHeadline5({Color? color}) {
    return TextStyle(
        fontFamily: '.SF UI Text',
        fontWeight: FontWeight.w400,
        fontSize: 24,
        height: 1.333,
        color: color);
  }

  static TextStyle headline6({Color? color}) =>
      Platform.isAndroid ? _androidHeadline6(color: color) : _iosHeadline6(color: color);

  static TextStyle _androidHeadline6({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        height: 1.56,
        letterSpacing: 0.15,
        color: color);
  }

  static TextStyle _iosHeadline6({Color? color}) {
    return TextStyle(
        fontFamily: '.SF UI Text',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        height: 1.56,
        letterSpacing: 0.15,
        color: color);
  }

  static TextStyle headline7({Color? color}) =>
      Platform.isAndroid ? _androidHeadline7(color: color) : _iosHeadline7(color: color);

  static TextStyle _androidHeadline7({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 18,
        height: 1.556,
        letterSpacing: 0.15,
        color: color);
  }

  static TextStyle _iosHeadline7({Color? color}) {
    return TextStyle(
        fontFamily: '.SF UI Display',
        fontWeight: FontWeight.w600,
        fontSize: 17,
        height: 1.647,
        letterSpacing: -0.21,
        color: color);
  }

  static TextStyle headerStyle({Color? color}) =>
      Platform.isAndroid ? _androidHeaderStyle(color: color) : _iosHeaderStyle(color: color);

  static TextStyle _androidHeaderStyle({Color? color}) {
    return TextStyle(
        color: color,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        letterSpacing: 0.15);
  }

  static TextStyle _iosHeaderStyle({Color? color}) {
    return TextStyle(
        color: color,
        fontFamily: '.SF UI Text',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.333);
  }

  static TextStyle overline({Color? color}) =>
      Platform.isAndroid ? _androidOverline(color: color) : _iosOverline(color: color);

  static TextStyle _androidOverline({Color? color}) {
    return TextStyle(
        color: color,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 10,
        height: 1.6,
        letterSpacing: 1.5);
  }

  static TextStyle _iosOverline({Color? color}) {
    return TextStyle(
        color: color,
        fontFamily: '.SF UI Text',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.333);
  }

  static final projectTitle = Platform.isAndroid ? _androidProjectTitle : _iosProjectTitle;
  static const TextStyle _androidProjectTitle = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.25,
      letterSpacing: 0.15);
  static const TextStyle _iosProjectTitle = TextStyle(
      fontFamily: '.SF UI Text',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.25,
      letterSpacing: 0.15);

  static TextStyle status({Color? color}) =>
      Platform.isAndroid ? _androidStatus(color: color) : _iosStatus(color: color);

  static TextStyle _androidStatus({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.5);
  }

  static TextStyle _iosStatus({Color? color}) {
    return TextStyle(
        fontFamily: '.SF UI Text',
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.5);
  }

  static final subtitleProjects =
      Platform.isAndroid ? _androidSubtitleProjects : _iosSubtitleProjects;
  static final TextStyle _androidSubtitleProjects = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Get.theme.colors().projectsSubtitle);
  static final TextStyle _iosSubtitleProjects = TextStyle(
      fontFamily: '.SF UI Text',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Get.theme.colors().projectsSubtitle);

  static final projectsSorting = Platform.isAndroid ? _androidProjectsSorting : _iosProjectsSorting;
  static final TextStyle _androidProjectsSorting = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Get.theme.colors().primary);
  static final TextStyle _iosProjectsSorting = TextStyle(
      fontFamily: '.SF UI Text',
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Get.theme.colors().primary);

  static final projectResponsible =
      Platform.isAndroid ? _androidProjectResponsible : _iosProjectResponsible;
  static final TextStyle _androidProjectResponsible = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: Get.theme.colors().projectsSubtitle,
  );
  static final TextStyle _iosProjectResponsible = TextStyle(
    fontFamily: '.SF UI Text',
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: Get.theme.colors().projectsSubtitle,
  );

  static final projectDate = Platform.isAndroid ? _androidProjectDate : _iosProjectDate;
  static final TextStyle _androidProjectDate = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 16,
      color: Get.theme.colors().projectsSubtitle);
  static final TextStyle _iosProjectDate = TextStyle(
      fontFamily: '.SF UI Text',
      fontWeight: FontWeight.normal,
      fontSize: 16,
      color: Get.theme.colors().projectsSubtitle);

  static final projectCompletedTasks =
      Platform.isAndroid ? _androidProjectCompletedTasks : _iosProjectCompletedTasks;
  static final TextStyle _androidProjectCompletedTasks = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Get.theme.colors().onSurface.withOpacity(0.6),
  );
  static final TextStyle _iosProjectCompletedTasks = TextStyle(
    fontFamily: '.SF UI Text',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Get.theme.colors().onSurface.withOpacity(0.6),
  );

  static const subHeaderStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle subtitle1({Color? color}) =>
      Platform.isAndroid ? _androidSubtitle1(color: color) : _iosSubtitle1(color: color);

  static TextStyle _androidSubtitle1({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w400,
        color: color);
  }

  static TextStyle _iosSubtitle1({Color? color}) {
    return TextStyle(
        fontFamily: '.SF UI Display',
        fontSize: 15,
        height: 1.333,
        letterSpacing: -0.08,
        fontWeight: FontWeight.w600,
        color: color);
  }

  static TextStyle subtitle2({Color? color}) =>
      Platform.isAndroid ? _androidSubtitle2(color: color) : _iosSubtitle2(color: color);

  static TextStyle _androidSubtitle2({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        height: 1.429,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w500,
        color: color);
  }

  static TextStyle _iosSubtitle2({Color? color}) {
    return TextStyle(
        fontFamily: '.SF UI Display',
        fontSize: 15,
        height: 1.333,
        letterSpacing: -0.08,
        fontWeight: FontWeight.w600,
        color: color);
  }
}
