import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/presentation/shared/custom_theme.dart';

class TextStyleHelper {
  static TextStyle mainStyle = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);

  static TextStyle headerStyle = TextStyle(
      fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.w500);

  static TextStyle subHeaderStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
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
}
