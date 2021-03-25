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