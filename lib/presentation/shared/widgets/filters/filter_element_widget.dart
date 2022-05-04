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

class FilterElement extends StatelessWidget {
  final bool isSelected;
  final String? title;
  final Color? titleColor;
  final bool? cancelButtonEnabled;
  final Function()? onTap;
  final Function()? onCancelTap;

  const FilterElement(
      {Key? key,
      this.isSelected = false,
      this.title,
      this.titleColor,
      this.onTap,
      this.cancelButtonEnabled = false,
      this.onCancelTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 32),
      child: PlatformTextButton(
        onPressed: onTap,
        cupertino: (_, __) => CupertinoTextButtonData(
          padding: const EdgeInsets.only(top: 5, bottom: 6, left: 12, right: 12),
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? Theme.of(context).colors().primary
              : Theme.of(context).colors().bgDescription,
        ),
        material: (_, __) => MaterialTextButtonData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.only(top: 5, bottom: 6, left: 12, right: 12)),
            backgroundColor: MaterialStateProperty.all<Color>(isSelected
                ? Theme.of(context).colors().primary
                : Theme.of(context).colors().bgDescription),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Theme.of(context).colors().outline, width: 0.5)),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(title!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.body2(
                      color: isSelected
                          ? Theme.of(context).colors().onPrimarySurface
                          : titleColor ?? Theme.of(context).colors().primary)),
            ),
            if (cancelButtonEnabled!)
              Padding(
                  padding: const EdgeInsets.only(left: 9),
                  child: InkWell(
                      onTap: onCancelTap,
                      child: Icon(PlatformIcons(context).clearThickCircled,
                          color: Colors.white, size: 18))),
          ],
        ),
      ),
    );
  }
}
