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

class CustomTab extends StatelessWidget {
  final String title;
  final int count;
  final bool currentTab;
  const CustomTab({
    Key key,
    this.title,
    this.count,
    this.currentTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Text(title),
          if (count != null && count >= 0) const SizedBox(width: 8),
          if (count != null && count >= 0)
            Container(
              height: 21,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:
                    Theme.of(context).customColors().onSurface.withOpacity(0.3),
                // TODO change active tabs color
                // color: currentTab
                //     ? Theme.of(context).customColors().primary
                //     : Theme.of(context)
                //         .customColors()
                //         .onSurface
                //         .withOpacity(0.3),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 6, right: 6),
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).customColors().surface,
                      letterSpacing: 0.1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
