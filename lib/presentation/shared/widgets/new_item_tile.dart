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
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';

class NewItemTile extends StatelessWidget {
  final int? maxLines;
  final bool? isSelected;
  final bool enableBorder;
  final TextStyle? textStyle;
  final String? text;
  final String? icon;
  final String? caption;
  final Function()? onTap;
  final Color? textColor;
  final Color? selectedIconColor;
  final Color? iconColor;
  final Widget? suffix;
  final EdgeInsetsGeometry suffixPadding;
  final TextOverflow textOverflow;

  const NewItemTile({
    Key? key,
    this.caption,
    this.enableBorder = true,
    this.icon,
    this.iconColor,
    this.isSelected = false,
    this.maxLines,
    this.onTap,
    this.selectedIconColor,
    this.suffix,
    this.suffixPadding = const EdgeInsets.symmetric(horizontal: 25),
    this.textOverflow = TextOverflow.ellipsis,
    this.textColor,
    this.textStyle,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                _Icon(
                  icon: icon,
                  iconColor: iconColor,
                  isSelected: isSelected,
                  selectedIconColor: selectedIconColor,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: caption != null && caption!.isNotEmpty ? 10 : 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (caption != null && caption!.isNotEmpty)
                          Text(caption!,
                              style: TextStyleHelper.caption(
                                  color: Get.theme.colors().onBackground.withOpacity(0.75))),
                        Text(text!,
                            maxLines: maxLines,
                            overflow: textOverflow,
                            style: textStyle ??
                                TextStyleHelper.subtitle1(
                                    // ignore: prefer_if_null_operators
                                    color: textColor != null
                                        ? textColor
                                        : isSelected!
                                            ? Get.theme.colors().onBackground
                                            : Get.theme.colors().onSurface.withOpacity(0.4))),
                      ],
                    ),
                  ),
                ),
                if (suffix != null)
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(padding: suffixPadding, child: suffix)),
              ],
            ),
            if (enableBorder) const StyledDivider(leftPadding: 72.5),
          ],
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    Key? key,
    this.icon,
    this.selectedIconColor,
    this.iconColor,
    this.isSelected,
  }) : super(key: key);

  final bool? isSelected;
  final Color? selectedIconColor;
  final Color? iconColor;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: icon != null
          ? AppIcon(
              icon: icon,
              color: selectedIconColor != null
                  ? isSelected!
                      ? selectedIconColor
                      : iconColor ?? Get.theme.colors().onSurface.withOpacity(0.4)
                  : iconColor ?? Get.theme.colors().onSurface.withOpacity(0.4),
            )
          : null,
    );
  }
}
