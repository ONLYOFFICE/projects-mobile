import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/app_colors.dart';

class TextStyleHelper {

  static final body1 = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0.44,
    color: AppColors.onBackground
  );

  static const body2 = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.429,
    letterSpacing: 0.25,
    color: AppColors.onSurface
  );

  static final caption = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.6,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface.withOpacity(0.75)
  );

  static const mainStyle = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);

  static const h6 = TextStyle(
    fontFamily: 'Roboto', 
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1.172,
    letterSpacing: 0.15,
    color: AppColors.onSurface
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
    color: AppColors.onSurface.withOpacity(0.6)
  );

  static const projectTitle = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.25,
    letterSpacing: 0.15
  );

  static const projectStatus = TextStyle(
    fontFamily: 'Roboto',
    color: AppColors.links,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.5
  );

  static const projectsSorting = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Color.fromRGBO(0, 0, 0, 0.6));

  static final projectResponsible = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 12,
      height: 1.33,
      letterSpacing: 0.5,
      color: AppColors.onSurface.withOpacity(0.6));

  static final projectDate = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    fontSize: 12,
    height: 0.33,
    letterSpacing: 0.5
  );

  static const projectCompleatetTasks = TextStyle(
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

  static const subtitleProjects = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color.fromRGBO(0, 0, 0, 0.6));


}
