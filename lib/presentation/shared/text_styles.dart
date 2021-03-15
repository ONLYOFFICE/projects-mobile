import 'package:flutter/material.dart';

class TextStyleHelper {
  static const mainStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  static const headerStyle = TextStyle(
      fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.w500);

  static const subHeaderStyle =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500);

  static const projectTitle = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static const projectResponsible = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: Color.fromRGBO(0, 0, 0, 0.6));

  static const projectDate = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 16,
      color: Color.fromRGBO(0, 0, 0, 0.6));

  static const projectCompleatetTasks = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Color(0xFF4294F7));
}
