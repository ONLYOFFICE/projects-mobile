import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class AuthTextField extends StatelessWidget {
  final bool obscureText;
  final bool hasError;
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
    this.hasError = false,
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
      style: TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 12, bottom: 8),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: hintText,
        labelStyle: TextStyleHelper.caption(
            color: Get.theme.colors().onSurface.withOpacity(0.6)),
        hintText: hintText,
        hintStyle: TextStyleHelper.subtitle1(
          color: !hasError
              ? Get.theme.colors().onSurface.withOpacity(0.6)
              : Get.theme.colors().colorError,
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Get.theme.colors().onSurface.withOpacity(0.42))),
      ),
    );
  }
}
