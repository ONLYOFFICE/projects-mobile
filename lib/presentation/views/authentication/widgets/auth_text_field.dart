/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class AuthTextField extends StatelessWidget {
  final bool obscureText;
  final bool hasError;
  final Function(String value)? onChanged;
  final String? hintText;
  final String? autofillHint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const AuthTextField(
      {Key? key,
      this.autofillHint,
      required this.controller,
      this.hintText,
      this.keyboardType,
      this.obscureText = false,
      this.onChanged,
      this.validator,
      this.hasError = false,
      this.onSubmitted,
      this.textInputAction,
      this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      focusNode: focusNode,
      controller: controller,
      autofillHints: autofillHint != null ? [autofillHint!] : null,
      onChanged: onChanged,
      obscureText: obscureText,
      obscuringCharacter: '*',
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: TextStyleHelper.subtitle1(
        color: hasError ? Get.theme.colors().colorError : Get.theme.colors().onSurface,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 12, bottom: 8),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: hintText,
        labelStyle: TextStyleHelper.caption(
          color: hasError && controller.text.isEmpty
              ? Get.theme.colors().colorError
              : Get.theme.colors().onSurface.withOpacity(0.6),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Get.theme.colors().onSurface.withOpacity(0.42))),
      ),
    );
  }
}
