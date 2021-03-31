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

  static TextStyle body2({Color color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.429,
        letterSpacing: 0.25,
        color: color);
  }

  static TextStyle button({Color color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.714,
        letterSpacing: 1.5,
        color: color);
  }

  static TextStyle caption({Color color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.6,
        fontWeight: FontWeight.w400,
        color: color);
  }

  static const mainStyle = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);

  static TextStyle h6({Color color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        height: 1.172,
        letterSpacing: 0.15,
        color: color);
  }

  static const headline6 = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      fontSize: 20,
      height: 1.56,
      letterSpacing: 0.15,
      color: Color.fromRGBO(0, 0, 0, 0.87));

  static TextStyle headline7({Color color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 18,
        height: 1.556,
        letterSpacing: 0.15,
        color: color);
  }

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

  static TextStyle subtitle1({Color color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w400,
        color: color);
  }

  static const subtitle2 = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      height: 1.429,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w500);
}
