import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/app_colors.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/theme/theme_service.dart';

extension ThemeDataExtensions on ThemeData {
  AppColors customColors() {
    if (ThemeService().isDark()) return darkColors;
    return lightColors;
  }
}

AppColors customTheme(BuildContext context) => Theme.of(context).customColors();

final AppColors lightColors = AppColors(
  activeTabTitle: const Color(0xffffffff),
  background: const Color(0xffFBFBFB),
  backgroundColor: const Color(0xffffffff),
  bgDescription: const Color(0xffF1F3F8),
  inactiveTabTitle: const Color(0xffffffff).withOpacity(0.4),
  lightSecondary: const Color(0xffED7309),
  links: const Color(0xff0C76D5),
  onBackground: const Color(0xff000000),
  onPrimary: const Color(0xffffffff),
  onPrimarySurface: const Color(0xffffffff),
  onSurface: const Color(0xff000000),
  outline: const Color(0xffD8D8D8),
  primary: const Color(0xff1A73E9),
  primarySurface: const Color(0xff0F4071),
  projectsSubtitle: const Color(0xff000000).withOpacity(0.6),
  snackBarColor: const Color(0xff333333),
  systemBlue: const Color(0xff007aff),
  surface: const Color(0xffffffff),
  tabActive: const Color.fromRGBO(255, 255, 255, 1),
  tabSecondary: const Color.fromRGBO(255, 255, 255, 0.4),
  tabbarBackground: const Color(0xff2E4057),
  error: const Color(0xffFF0C3E),
);

// ignore: missing_required_param
final AppColors darkColors = AppColors(
    backgroundColor: const Color(0xff000000),
    activeTabTitle: const Color(0xffffffff),
    inactiveTabTitle: const Color(0xffffffff).withOpacity(0.4),
    tabbarBackground: const Color(0xff2E4057),
    projectsSubtitle: const Color(0xffffffff).withOpacity(0.6),
    background: const Color(0xffFBFBFB),
    links: const Color(0xff0C76D5),
    onSurface: const Color(0xff000000),
    primarySurface: const Color(0xff0F4071),
    primary: const Color(0xff0C76D5));

final ThemeData lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  backgroundColor: const Color(0xffffffff),
  scaffoldBackgroundColor: lightColors.backgroundColor,
  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(color: Color(0xff1A73E9)),
    backgroundColor: Colors.blue, //lightColors.onPrimarySurface,
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
  backgroundColor: const Color(0xff000000),
);
