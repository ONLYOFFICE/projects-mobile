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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class FiltersHeader extends StatelessWidget {
  const FiltersHeader({
    Key key,
    @required this.filterController,
  }) : super(key: key);

  final BaseFilterController filterController;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SizedBox(
        height: 68,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 4,
                  width: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 18.5,
                left: 16,
                child: Text(tr('filter'),
                    style: TextStyleHelper.h6(
                        color: Theme.of(context).customColors().onSurface))),
            Positioned(
                top: 5,
                right: 5,
                child: TextButton(
                    onPressed: () async {
                      filterController.resetFilters();
                      Get.back();
                    },
                    child: Text(tr('reset'),
                        style: TextStyleHelper.button(
                            color:
                                Theme.of(context).customColors().systemBlue)))),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 1,
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}
