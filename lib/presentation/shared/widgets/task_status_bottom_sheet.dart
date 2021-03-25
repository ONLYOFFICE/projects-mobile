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
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';

class BottomSheet extends StatelessWidget {

  final String title;
  const BottomSheet({
    Key key,
    this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 464,
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 18.5),
              child: SizedBox(
                height: 4,
                width: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).customColors().onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2)
                  ),
                ),
              ),
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: TextStyleHelper.h6,
              ),
            ),
          const SizedBox(height: 14.5),
          Divider(height: 9),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            selected: true,
            title: 'Задача создана',
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача назначена',
            selected: false, 
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача открыта',
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача на паузе',
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача выполнена',
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача завершена',
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача на подтверждении',
          ),
          StatusTile(
            icon: Icon(Icons.ac_unit),
            title: 'Задача отменена',
          ),
        ],
      ),
    );
  }
}


class StatusTile extends StatelessWidget {

  final String title;
  final Widget icon;
  final bool selected;

  const StatusTile({
    Key key,
    this.icon,
    this.title,
    this.selected = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    BoxDecoration _selectedDecoration(){

      return BoxDecoration(
        color: Theme.of(context).customColors().bgDescription,
        borderRadius: BorderRadius.circular(6)
      );

    }
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
      decoration: selected
          ? _selectedDecoration() 
          : null,
      child: Stack(
        children: [
          Positioned(
            left: 15,
            top: 10,
            bottom: 10,
            child: icon
          ),
          Positioned(
            left: 48,
            top: 10,
            bottom: 10,
            child: Text(title, style: TextStyleHelper.body2)),
          if (selected)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.done_sharp
                ),
              ),
            )
        ],
      ),
    );
  }
}