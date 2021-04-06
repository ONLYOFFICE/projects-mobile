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
  const _Project({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FilterLabel(label: 'Project'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(runSpacing: 16, spacing: 16, children: [
              _FilterElement(
                  title: 'My projects',
                  titleColor: Theme.of(context).customColors().onSurface,
                  selected: filterController.project['My'],
                  onTap: () => filterController.changeProject('My')),
              _FilterElement(
                  title: filterController.project['Other'].isEmpty
                      ? 'Other projects'
                      : filterController.project['Other'],
                  selected: filterController.project['Other'].isNotEmpty,
                  cancelButton: filterController.project['Other'].isNotEmpty,
                  onTap: () async {
                    var selectedProject =
                        await Get.bottomSheet(SelectProject());
                    filterController.changeProject('Other', selectedProject);
                  },
                  onCancelTap: () =>
                      filterController.changeProject('Other', null)),
              _FilterElement(
                  title: 'With tag',
                  selected: filterController.project['With tag'],
                  onTap: () async {
                    var selectedTag = await Get.bottomSheet(SelectTag());
                    filterController.changeProject('With tag', selectedTag);
                  }),
              _FilterElement(
                  title: 'Without tag',
                  selected: filterController.project['Without tag'],
                  onTap: () => filterController.changeProject('Without tag')),
            ]),
          ),
        ],
      ),
    );
  }
}
