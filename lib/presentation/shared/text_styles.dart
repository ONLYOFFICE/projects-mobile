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

import 'package:projects/presentation/shared/custom_theme.dart';

class TextStyleHelper {

  static final body1 = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0.44,
    // color: AppColors.onBackground
  );

  static const body2 = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.429,
    letterSpacing: 0.25,
    // color: AppColors.onSurface
  );

  static final caption = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.6,
    fontWeight: FontWeight.w400,
    // color: AppColors.onSurface.withOpacity(0.75)
  );

  static const mainStyle = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);

  static const h6 = TextStyle(
    fontFamily: 'Roboto', 
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1.172,
    letterSpacing: 0.15,
    // color: AppColors.onSurface
  );

  static const headline6 = TextStyle(
    fontFamily: 'Roboto', 
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1.4,
    letterSpacing: 0.15,
    color: Color.fromRGBO(0, 0, 0, 0.87)
  );

  static const headerStyle = TextStyle(
      fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.w500);


  static final overline = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 1.6,
    letterSpacing: 1.5,
    // color: AppColors.onSurface.withOpacity(0.6)
  );

  static TextStyle projectTitle = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.25,
      letterSpacing: 0.15);

  static TextStyle projectStatus = TextStyle(
      fontFamily: 'Roboto',
      color: Get.theme.customColors().links,
      fontWeight: FontWeight.w500,
      fontSize: 12,
      height: 1.33,
      letterSpacing: 0.5);

  static TextStyle taskStatus(Color color) {
    return TextStyle(
      fontFamily: 'Roboto',
      color: color,
      fontWeight: FontWeight.w500,
      fontSize: 12,
      height: 1.33,
      letterSpacing: 0.5);
  }

  static TextStyle subtitleProjects = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Get.theme.customColors().projectsSubtitle);

  static TextStyle projectsSorting = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Get.theme.customColors().projectsSubtitle);

  static TextStyle projectResponsible = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: Get.theme.customColors().projectsSubtitle,
  );

  static TextStyle projectDate = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 16,
      color: Get.theme.customColors().projectsSubtitle);

  static TextStyle projectCompleatedTasks = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Color(0xFF4294F7));

  static const subHeaderStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  static const subtitle1 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0.15,
    fontWeight: FontWeight.w400,
  );

  static const subtitle2 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    height: 1.429,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w500
  );


}
