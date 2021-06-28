import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class AuthTextField extends StatelessWidget {
  final bool obscureText;
  final bool haveError;
  final Function(String value) onChanged;
  final String hintText;
  final String autofillHint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final validator;

  const AuthTextField({
    Key key,
    this.autofillHint,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.haveError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofillHints: [autofillHint],
      onChanged: onChanged,
      obscureText: obscureText,
      obscuringCharacter: '*',
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyleHelper.subtitle1(
          color: Theme.of(context).customColors().onSurface),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 12, bottom: 8),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: hintText,
        labelStyle: TextStyleHelper.caption(
            color: Theme.of(context).customColors().onSurface.withOpacity(0.6)),
        hintText: hintText,
        hintStyle: TextStyleHelper.subtitle1(
          color: !haveError
              ? Theme.of(context).customColors().onSurface.withOpacity(0.6)
              : Theme.of(context).customColors().error,
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context)
                    .customColors()
                    .onSurface
                    .withOpacity(0.42))),
      ),
    );
  }
}
