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
  backgroundColor: Colors.white,
  activeTabTitle: Colors.white,
  inactiveTabTitle: Colors.white.withOpacity(0.4),
  tabbarBackground: Color(0xff2E4057),
  projectsSubtitle: Colors.black.withOpacity(0.6),
  background: Color(0xffFBFBFB),
  links: Color(0xff0C76D5),
  onSurface: Color(0xff000000),
  primarySurface: Color(0xff0F4071),
);

final AppColors darkColors = AppColors(
  backgroundColor: Colors.black,
  activeTabTitle: Colors.white,
  inactiveTabTitle: Colors.white.withOpacity(0.4),
  tabbarBackground: Color(0xff2E4057),
  projectsSubtitle: Colors.white.withOpacity(0.6),
  background: Color(0xffFBFBFB),
  links: Color(0xff0C76D5),
  onSurface: Color(0xff000000),
  primarySurface: Color(0xff0F4071),
);

final ThemeData lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  backgroundColor: Colors.white,
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  backgroundColor: Colors.black,
);
