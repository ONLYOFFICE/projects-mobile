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

part of '../discussions_filter_screen.dart';

class _CreatingDate extends StatelessWidget {
  final DiscussionsFilterController filterController;
  const _CreatingDate({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('creationDate'),
        options: <Widget>[
          FilterElement(
              title: tr('today'),
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.creationDate['today'],
              onTap: () => filterController.changeCreationDate(('today'))),
          FilterElement(
              title: tr('last7Days'),
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.creationDate['last7Days'],
              onTap: () => filterController.changeCreationDate(('last7Days'))),
          FilterElement(
              title: tr('customPeriod'),
              isSelected: filterController.creationDate['custom']['selected'],
              onTap: () =>
                  selectDateRange(context, filterController: filterController)),
        ],
      ),
    );
  }
}

Future selectDateRange(
  BuildContext context, {
  DiscussionsFilterController filterController,
}) async {
  var pickedRange = await showDateRangePicker(
    context: context,
    initialDateRange: DateTimeRange(
      start: filterController.creationDate['custom']['startDate'],
      end: filterController.creationDate['custom']['stopDate'],
    ),
    firstDate: DateTime(1970),
    lastDate: DateTime(DateTime.now().year + 2),
    helpText: tr('selectDateRange'),
    cancelText: tr('cancel'),
    confirmText: tr('ok'),
    saveText: tr('save'),
    errorFormatText: tr('invalidFormat'),
    errorInvalidText: tr('outOfRange'),
    errorInvalidRangeText: tr('invalidRange'),
    fieldStartHintText: tr('startDate'),
    fieldEndLabelText: tr('endDate'),
  );

  if (pickedRange != null) {
    await filterController.changeCreationDate(
      'custom',
      start: pickedRange.start,
      stop: pickedRange.end,
    );
  }
}