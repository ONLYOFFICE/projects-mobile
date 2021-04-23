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

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class FilterElement extends StatelessWidget {
  final bool isSelected;
  final String title;
  final Color titleColor;
  final bool cancelButtonEnabled;
  final Function() onTap;
  final Function() onCancelTap;

  const FilterElement(
      {Key key,
      this.isSelected = false,
      this.title,
      this.titleColor,
      this.onTap,
      this.cancelButtonEnabled = false,
      this.onCancelTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.only(top: 5, bottom: 6, left: 12, right: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffD8D8D8), width: 0.5),
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? Theme.of(context).customColors().primary
              : Theme.of(context).customColors().bgDescription,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.body2(
                      color: isSelected
                          ? Theme.of(context).customColors().onPrimarySurface
                          : titleColor ??
                              Theme.of(context).customColors().primary)),
            ),
            if (cancelButtonEnabled)
              Padding(
                  padding: const EdgeInsets.only(left: 9),
                  child: InkWell(
                      onTap: onCancelTap,
                      child: const Icon(Icons.cancel,
                          color: Colors.white, size: 18))),
          ],
        ),
      ),
    );
  }
}
