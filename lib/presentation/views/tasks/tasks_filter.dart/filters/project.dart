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

class _Project extends StatelessWidget {
  final BaseTaskFilterController filterController;
  const _Project({Key? key, required this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('project'),
        options: <Widget>[
          FilterElement(
              title: tr('myProjects'),
              titleColor: Theme.of(context).colors().onSurface,
              isSelected: filterController.project['my'] as bool,
              onTap: () => filterController.changeProject('my')),
          FilterElement(
              title: filterController.project['other'].isEmpty as bool
                  ? tr('otherProjects')
                  : filterController.project['other'] as String,
              isSelected: filterController.project['other'].isNotEmpty as bool,
              cancelButtonEnabled: filterController.project['other'].isNotEmpty as bool?,
              onTap: () async {
                final selectedProject = await Get.find<NavigationController>().toScreen(
                  SelectProjectScreen(),
                  transition: Transition.rightToLeft,
                  page: '/SelectProjectScreen',
                  arguments: {'previousPage': TasksFilterScreen.pageName},
                );
                filterController.changeProject('other', selectedProject);
              },
              onCancelTap: () => filterController.changeProject('other', null)),
          FilterElement(
              title: filterController.project['withTag'].isEmpty as bool
                  ? tr('withTag')
                  : filterController.project['withTag'] as String,
              isSelected: filterController.project['withTag'].isNotEmpty as bool,
              cancelButtonEnabled: filterController.project['withTag'].isNotEmpty as bool?,
              onTap: () async {
                final selectedTag = await Get.find<NavigationController>().toScreen(
                  const SelectTagScreen(),
                  transition: Transition.rightToLeft,
                  page: '/SelectTagScreen',
                  arguments: {'previousPage': TasksFilterScreen.pageName},
                );
                filterController.changeProject('withTag', selectedTag);
              },
              onCancelTap: () => filterController.changeProject('withTag', null)),
          FilterElement(
              title: tr('withoutTag'),
              titleColor: Theme.of(context).colors().onSurface,
              isSelected: filterController.project['withoutTag'] as bool,
              onTap: () => filterController.changeProject('withoutTag')),
        ],
      ),
    );
  }
}
