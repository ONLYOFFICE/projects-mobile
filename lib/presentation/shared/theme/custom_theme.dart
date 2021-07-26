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
  systemBlue: const Color(0xff007aff),
  surface: const Color(0xffffffff),
  tabbarBackground: const Color(0xff2E4057),
  colorError: const Color(0xffFF0C3E),
);

final AppColors darkColors = AppColors(
  primary: const Color(0xff3E9CF0),
  onNavBar: const Color(0xffFFFFFF),
  backgroundColor: const Color(0xff121212),
  tabbarBackground: const Color(0xff2E4057),
  projectsSubtitle: const Color(0xffffffff).withOpacity(0.6),
  background: const Color(0xff121212),
  links: const Color(0xff0C76D5),
  surface: const Color(0xff252525),
  onSurface: const Color.fromRGBO(255, 255, 255, 0.87),
  primarySurface: const Color(0xff191919),
  bgDescription: const Color(0xff363636),
  lightSecondary: const Color(0xffFFAF49),
  onBackground: const Color(0xffffffff),
  onPrimary: const Color(0xffffffff),
  onPrimarySurface: const Color(0xff000000),
  outline: const Color(0xff3F3F3F),
  snackBarColor: const Color(0xff333333),
  systemBlue: const Color(0xff007aff),
  colorError: const Color(0xffFF5679),
);

final ThemeData lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  backgroundColor: lightColors.backgroundColor,
  scaffoldBackgroundColor: lightColors.backgroundColor,
  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(color: Color(0xff1A73E9)),
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
    iconTheme: const IconThemeData(color: Color(0xff1A73E9)),
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
