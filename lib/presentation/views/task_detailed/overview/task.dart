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

part of 'tasks_overview_screen.dart';

class _Task extends StatelessWidget {
  final TaskItemController? taskController;

  const _Task({Key? key, required this.taskController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SizedBox(
                width: 72,
                child: AppIcon(
                  icon: SvgIcons.tab_bar_tasks,
                  color: Get.theme.colors().onBackground.withOpacity(0.6),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 26, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('task'),
                      style: TextStyleHelper.overline(
                          color: Get.theme.colors().onBackground.withOpacity(0.6)),
                    ),
                    Obx(
                      () => Text(
                        taskController!.task.value.title!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleHelper.headline6(
                          color: Get.theme.colors().onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 72, bottom: 25, top: 15),
          child: Obx(
            () => StatusButton(
              canEdit: taskController!.task.value.canEdit!,
              text: taskController?.status.value.title ?? '',
              onPressed: taskController!.openStatuses,
            ),
          ),
        ),
      ],
    );
  }
}
