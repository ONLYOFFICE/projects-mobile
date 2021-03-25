import 'package:flutter/material.dart';

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
  );

  static TextStyle subtitleProjects(ThemeData theme) => TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: theme.customColors().projectsSubtitle);

  static TextStyle projectsSorting(ThemeData theme) => TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: theme.customColors().projectsSubtitle);

  static TextStyle projectResponsible(ThemeData theme) => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: theme.customColors().projectsSubtitle,
      );

  static TextStyle projectDate(ThemeData theme) => TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 16,
      color: theme.customColors().projectsSubtitle);

  static TextStyle projectCompleatedTasks = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Color(0xFF4294F7));
}
