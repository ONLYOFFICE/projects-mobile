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
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class WideButton extends StatelessWidget {
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry padding;
  final Function() onPressed;
  final String text;
  const WideButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.padding = const EdgeInsets.only(top: 10, bottom: 12),
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: PlatformTextButton(
          onPressed: onPressed,
          padding: padding,
          child: Text(
            text,
            style: TextStyleHelper.button(color: textColor ?? Get.theme.colors().onNavBar),
          ),
          material: (context, platform) => MaterialTextButtonData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(color ?? Get.theme.colors().primary),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)))),
          ),
          cupertino: (context, platform) => CupertinoTextButtonData(
              color: color ?? Get.theme.colors().primary,
              disabledColor: Get.theme.colors().surface,
              borderRadius: BorderRadius.circular(6)),
        ));
  }
}
