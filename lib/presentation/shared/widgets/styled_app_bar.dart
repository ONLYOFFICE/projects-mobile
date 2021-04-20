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

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final String titleText;
  final bool centerTitle;
  final bool showBackButton;
  final double bottomHeight;
  final List<Widget> actions;
  final Widget bottom;
  final double elevation;
  final Widget leading;
  final double titleHeight;

  StyledAppBar(
      {Key key,
      this.actions,
      this.elevation = 1,
      this.title,
      this.titleHeight = 56,
      this.titleText,
      this.centerTitle,
      this.bottom,
      this.bottomHeight = 44,
      this.showBackButton = true,
      this.leading})
      : assert(titleText == null || title == null),
        // assert((bottom != null || bottomHeight == null) ||
        //     (bottom == null && bottomHeight == null)),
        // assert((bottom != null || bottomHeight == null)),
        preferredSize = Size.fromHeight(
            bottom != null ? titleHeight + bottomHeight : titleHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      iconTheme: IconThemeData(color: const Color(0xff1A73E9)),
      backgroundColor: lightColors.onPrimarySurface,
      automaticallyImplyLeading: showBackButton,
      elevation: elevation,
      leading: leading,
      textTheme: TextTheme(
          headline6: TextStyleHelper.headline6(color: lightColors.onSurface)),
      actions: actions,
      // ignore: prefer_if_null_operators
      title: title != null
          ? title
          : titleText != null
              ? Text(titleText)
              : null,
      bottom: bottom == null
          ? null
          : PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight), child: bottom),
    );
  }
}
