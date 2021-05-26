import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class AuthTextField extends StatelessWidget {
  final bool obscureText;
  final Function(String value) onChanged;
  final String hintText;
  final String autofillHint;
  final TextEditingController controller;
  const AuthTextField({
    Key key,
    @required this.controller,
    @required this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.autofillHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofillHints: [autofillHint],
      onChanged: onChanged,
      obscureText: obscureText,
      obscuringCharacter: '*',
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 12, bottom: 8),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: hintText,
          labelStyle: TextStyleHelper.caption(
              color:
                  Theme.of(context).customColors().onSurface.withOpacity(0.6)),
          hintText: hintText,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.42)))),
    );
  }
}
