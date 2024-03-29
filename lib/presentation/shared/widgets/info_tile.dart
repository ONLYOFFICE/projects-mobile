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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class InfoTile extends StatelessWidget {
  final Widget? icon;
  final String? caption;
  final String? subtitle;
  final TextStyle? captionStyle;
  final TextStyle? subtitleStyle;
  final Widget? subtitleWidget;
  final Widget? suffix;
  final Function()? onTap;
  final bool privateIconVisible;

  const InfoTile({
    Key? key,
    this.icon,
    this.caption,
    this.captionStyle,
    this.onTap,
    this.subtitle,
    this.subtitleStyle,
    this.subtitleWidget,
    this.suffix,
    this.privateIconVisible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(width: 72, child: icon),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (caption != null)
                  Text.rich(
                    TextSpan(
                      style: captionStyle ?? TextStyleHelper.caption(),
                      children: [
                        ...privateIconVisible
                            ? [
                                const WidgetSpan(
                                  child: AppIcon(icon: SvgIcons.lock),
                                  alignment: PlaceholderAlignment.middle,
                                ),
                                const WidgetSpan(
                                  child: SizedBox(width: 4),
                                ),
                              ]
                            : [],
                        TextSpan(text: caption),
                      ],
                    ),
                  ),
                if (subtitleWidget != null) subtitleWidget!,
                if (subtitleWidget == null && subtitle != null)
                  Text(subtitle!,
                      style: subtitleStyle ??
                          TextStyleHelper.subtitle1(color: Theme.of(context).colors().onSurface))
              ],
            ),
          ),
          if (suffix != null) suffix!,
          if (suffix == null) const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class InfoTileWithButton extends StatelessWidget {
  final Widget? icon;
  final String? caption;
  final String? subtitle;
  final TextStyle? captionStyle;
  final TextStyle? subtitleStyle;
  final IconData? iconData;
  final Function()? onTapFunction;

  const InfoTileWithButton({
    Key? key,
    this.icon,
    this.caption,
    this.captionStyle,
    this.subtitle,
    this.subtitleStyle,
    this.iconData,
    this.onTapFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 72, child: icon),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(caption!, style: captionStyle ?? TextStyleHelper.caption()),
              Text(subtitle!, style: subtitleStyle ?? TextStyleHelper.subtitle1())
            ],
          ),
        ),
        PlatformIconButton(
          onPressed: onTapFunction,
          icon: Icon(
            iconData,
            color: Theme.of(context).colors().onBackground.withOpacity(0.6),
          ),
        ),
        // const SizedBox(width: 23),
      ],
    );
  }
}
