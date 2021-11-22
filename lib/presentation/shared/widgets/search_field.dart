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

class SearchField extends StatelessWidget {
  final bool autofocus;
  final bool showClearIcon;
  final Color? color;
  final double? width;
  final double height;
  final String? hintText;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry margin;
  final TextEditingController? controller;
  final Function(String value)? onChanged;
  final Function(String value)? onSubmitted;
  final Function()? onSuffixTap;
  final Function()? onClearPressed;

  const SearchField({
    Key? key,
    this.autofocus = false,
    this.color,
    this.controller,
    this.height = 32,
    this.hintText,
    this.margin = const EdgeInsets.only(left: 16, right: 16, bottom: 10),
    this.onChanged,
    this.onClearPressed,
    this.onSubmitted,
    this.onSuffixTap,
    this.showClearIcon = false,
    this.suffixIcon,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        autofocus: autofocus,
        decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: color ?? Get.theme.colors().bgDescription,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(width: 0, style: BorderStyle.none)),
            labelStyle: TextStyleHelper.body2(
                color: Get.theme.colors().onSurface.withOpacity(0.4)),
            hintStyle: TextStyleHelper.body2(
                color: Get.theme.colors().onSurface.withOpacity(0.4)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            suffixIcon: showClearIcon
                ? GestureDetector(
                    onTap: onClearPressed,
                    child: const SizedBox(
                        height: 32,
                        width: 32,
                        child: Icon(Icons.clear_rounded)))
                : GestureDetector(
                    onTap: onSuffixTap,
                    child: SizedBox(height: 32, child: suffixIcon))),
      ),
    );
  }
}
