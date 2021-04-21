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

part of '../tasks_filter.dart';

class _Responsible extends StatelessWidget {
  const _Responsible({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();
    return Obx(
      () => FiltersRow(
        title: 'Responsible',
        options: <Widget>[
          FilterElement(
              title: 'Me',
              isSelected: filterController.responsible['Me'],
              onTap: () => filterController.changeResponsible('Me')),
          FilterElement(
              title: filterController.responsible['Other'].isEmpty
                  ? 'Other user'
                  : filterController.responsible['Other'],
              isSelected: filterController.responsible['Other'].isNotEmpty,
              cancelButtonEnabled:
                  filterController.responsible['Other'].isNotEmpty,
              onTap: () async {
                var newUser = await Get.bottomSheet(UsersBottomSheet());
                filterController.changeResponsible('Other', newUser);
              },
              onCancelTap: () =>
                  filterController.changeResponsible('Other', null)),
          FilterElement(
              title: filterController.responsible['Groups'].isEmpty
                  ? 'Groups'
                  : filterController.responsible['Groups'],
              isSelected: filterController.responsible['Groups'].isNotEmpty,
              cancelButtonEnabled:
                  filterController.responsible['Groups'].isNotEmpty,
              onTap: () async {
                var newGroup = await Get.bottomSheet(GroupsBottomSheet());
                filterController.changeResponsible('Groups', newGroup);
              },
              onCancelTap: () =>
                  filterController.changeResponsible('Groups', null)),
          FilterElement(
              title: 'No responsible',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.responsible['No'],
              onTap: () => filterController.changeResponsible('No'))
        ],
      ),
    );
  }
}

// class _Responsible extends StatelessWidget {
//   const _Responsible({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var filterController = Get.find<TaskFilterController>();
//     return Obx(
//       () => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const _FilterLabel(
//               label: 'Responsible',
//               padding: EdgeInsets.only(left: 16, bottom: 20.05)),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Wrap(runSpacing: 16, spacing: 16, children: [
//               _FilterElement(
//                   title: 'Me',
//                   selected: filterController.responsible['Me'],
//                   onTap: () => filterController.changeResponsible('Me')),
//               _FilterElement(
//                   title: filterController.responsible['Other'].isEmpty
//                       ? 'Other user'
//                       : filterController.responsible['Other'],
//                   selected: filterController.responsible['Other'].isNotEmpty,
//                   cancelButton:
//                       filterController.responsible['Other'].isNotEmpty,
//                   onTap: () async {
//                     var newUser = await Get.bottomSheet(SelectUser());
//                     filterController.changeResponsible('Other', newUser);
//                   },
//                   onCancelTap: () =>
//                       filterController.changeResponsible('Other', null)),
//               _FilterElement(
//                   title: filterController.responsible['Groups'].isEmpty
//                       ? 'Groups'
//                       : filterController.responsible['Groups'],
//                   selected: filterController.responsible['Groups'].isNotEmpty,
//                   cancelButton:
//                       filterController.responsible['Groups'].isNotEmpty,
//                   onTap: () async {
//                     var newGroup = await Get.bottomSheet(SelectGroup());
//                     filterController.changeResponsible('Groups', newGroup);
//                   },
//                   onCancelTap: () =>
//                       filterController.changeResponsible('Groups', null)),
//               _FilterElement(
//                   title: 'No responsible',
//                   titleColor: Theme.of(context).customColors().onSurface,
//                   selected: filterController.responsible['No'],
//                   onTap: () => filterController.changeResponsible('No'))
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
