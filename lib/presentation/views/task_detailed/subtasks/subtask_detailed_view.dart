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
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';

class SubtaskDetailedView extends StatelessWidget {
  const SubtaskDetailedView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubtaskController controller = Get.arguments['controller'];

    var _subtask = controller.subtask.value;

    return Scaffold(
      appBar: StyledAppBar(
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, size: 26),
            offset: const Offset(0, 25),
            // onSelected: (value) => _onSelected(value, controller),
            itemBuilder: (context) {
              return [
                if (_subtask.canEdit && _subtask.responsible == null)
                  const PopupMenuItem(value: 'Accept', child: Text('Accept')),
                if (_subtask.canEdit)
                  const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                const PopupMenuItem(value: 'Copy', child: Text('Copy')),
                if (_subtask.canEdit)
                  const PopupMenuItem(value: 'Delete', child: Text('Delete')),
              ];
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 56,
                      child: Checkbox(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _subtask.title,
                        style: TextStyleHelper.subtitle1(
                            color:
                                Theme.of(context).customColors().onBackground),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
                const SizedBox(height: 4),
                const StyledDivider(leftPadding: 56)
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 56, child: AppIcon(icon: SvgIcons.person)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Assigned to:',
                          style: TextStyleHelper.caption(
                              color: Theme.of(context)
                                  .customColors()
                                  .onBackground
                                  .withOpacity(0.75))),
                      Text(
                        _subtask?.responsible?.displayName ?? 'No responsible',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleHelper.subtitle1(
                            color: Theme.of(context).customColors().onSurface),
                      ),
                    ],
                  ),
                ),
                if (_subtask.responsible != null && _subtask.canEdit)
                  IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {},
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
