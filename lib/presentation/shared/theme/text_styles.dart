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

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

//TODO [akryukov] review styles after figma project will be updated
class TextStyleHelper {
  static final body1 = Platform.isAndroid ? _androidBody1 : _iosBody1;
  static const _androidBody1 = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.5,
      letterSpacing: 0.44);
  static const _iosBody1 = TextStyle(
    fontFamily: '.SF Pro',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
  );

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
        fontFamily: '.SF Pro Display',
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
    return TextStyle(
      fontFamily: '.SF Pro Display',
      fontSize: 16,
      height: 1.412,
      color: color,
    );
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
    return TextStyle(
      fontFamily: '.SF Pro Display',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.333,
      color: color,
    );
  }

  static final mainStyle = Platform.isAndroid ? _android_mainStyle : _ios_mainStyle;
  static const _android_mainStyle = TextStyle(fontFamily: 'Roboto', fontSize: 20);
  static const _ios_mainStyle = TextStyle(fontFamily: '.SF Pro Display', fontSize: 20);

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
        fontFamily: '.SF Pro Display',
        fontWeight: FontWeight.w400,
        fontSize: 34,
        height: 40 / 34,
        letterSpacing: 0.25,
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
        fontFamily: '.SF Pro Display',
        fontWeight: FontWeight.w600,
        fontSize: 17,
        height: 1.647,
        letterSpacing: -0.21,
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
        fontFamily: '.SF Pro Display',
        fontWeight: FontWeight.w600,
        fontSize: 17,
        height: 1.647,
        letterSpacing: -0.21,
        color: color);
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
      letterSpacing: 1.5,
    );
  }

  static TextStyle _iosOverline({Color? color}) {
    return TextStyle(
        color: color,
        fontFamily: '.SF Pro',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        fontSize: 12,
        height: 1.333);
  }

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
        fontFamily: '.SF Pro Display',
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.5);
  }

  static final projectsSorting = Platform.isAndroid ? _androidProjectsSorting : _iosProjectsSorting;
  static final TextStyle _androidProjectsSorting = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Get.theme.colors().primary);
  static final TextStyle _iosProjectsSorting = TextStyle(
      fontFamily: '.SF Pro Display',
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
    fontFamily: '.SF Pro Display',
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: Get.theme.colors().projectsSubtitle,
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
        height: 1.25,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w400,
        color: color);
  }

  static TextStyle _iosSubtitle1({Color? color}) {
    return TextStyle(
        fontFamily: '.SF Pro Display',
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
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
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: color);
  }

  static TextStyle _iosSubtitle2({Color? color}) {
    return TextStyle(
        fontFamily: '.SF Pro Display',
        fontSize: 15,
        height: 1.333,
        fontStyle: FontStyle.normal,
        letterSpacing: -0.08,
        fontWeight: FontWeight.w600,
        color: color);
  }

  static TextStyle navBar({Color? color}) =>
      Platform.isAndroid ? _androidNavBar(color: color) : _iosNavBar(color: color);

  static TextStyle _androidNavBar({Color? color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        height: 1.333,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: color);
  }

  static TextStyle _iosNavBar({Color? color}) {
    return TextStyle(
        fontFamily: '.SF Pro',
        fontSize: 12,
        height: 1.333,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        color: color);
  }
}
