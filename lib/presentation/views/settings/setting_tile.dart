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

class SettingTile extends StatelessWidget {
  final bool enableUnderline;
  // Some icons are black, so we need to use opacity to make all the
  // icons the same
  final bool enableIconOpacity;
  final TextStyle textStyle;
  final String text;
  final String suffixText;
  final String loverText;
  final String icon;
  final Function() onTap;
  final Color textColor;
  final Widget suffix;
  final EdgeInsetsGeometry suffixPadding;
  final TextOverflow textOverflow;

  const SettingTile({
    Key key,
    this.enableUnderline = false,
    this.enableIconOpacity = false,
    this.icon,
    this.loverText,
    this.onTap,
    this.suffix,
    this.suffixPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.suffixText,
    this.textOverflow = TextOverflow.ellipsis,
    this.textColor,
    this.textStyle,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: enableUnderline
            ? Border(
                bottom: BorderSide(
                    color: Theme.of(context).colors().outline.withOpacity(0.5)))
            : null,
      ),
      child: SizedBox(
        height: 60,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 72,
                    child: icon != null
                        ? AppIcon(
                            icon: icon,
                            color: Get.theme
                                .colors()
                                .onBackground
                                .withOpacity(enableIconOpacity ? 0.6 : 1))
                        : null,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: loverText != null && loverText.isNotEmpty
                              ? 8
                              : 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(text,
                              overflow: textOverflow,
                              style: textStyle ??
                                  TextStyleHelper.subtitle1(
                                      // ignore: prefer_if_null_operators
                                      color: textColor != null
                                          ? textColor
                                          : Get.theme.colors().onBackground)),
                          if (loverText != null && loverText.isNotEmpty)
                            Text(loverText,
                                style: TextStyleHelper.body2(
                                    color: Get.theme
                                        .colors()
                                        .onBackground
                                        .withOpacity(0.75))),
                        ],
                      ),
                    ),
                  ),
                  if (suffix != null)
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(padding: suffixPadding, child: suffix)),
                  if (suffixText != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: suffixPadding,
                        child: Text(
                          suffixText,
                          style: TextStyleHelper.body2(
                              color: Theme.of(context)
                                  .colors()
                                  .onSurface
                                  .withOpacity(0.6)),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
