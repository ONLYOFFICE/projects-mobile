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
import 'package:projects/domain/controllers/milestones/milestones_controller.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

class SelectMilestoneView extends StatelessWidget {
  final selectedId;
  const SelectMilestoneView({
    Key key,
    this.selectedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _milestoneController = Get.find<MilestonesController>();

    _milestoneController.getMilestonesByFilter();

    var controller = Get.find<NewTaskController>();

    return Scaffold(
      appBar: StyledAppBar(titleText: 'Select milestone', actions: [
        IconButton(
            icon: const Icon(Icons.check_rounded), onPressed: () => print('da'))
      ]),
      body: Column(
        children: [
          Obx(
            () {
              if (_milestoneController.loaded.isTrue) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: _milestoneController.milestones.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Material(
                        child: InkWell(
                          onTap: () {
                            controller.changeMilestoneSelection(
                                id: _milestoneController.milestones[index].id,
                                title: _milestoneController
                                    .milestones[index].title);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _milestoneController
                                            .milestones[index].title,
                                        style: TextStyleHelper.projectTitle,
                                      ),
                                      Text(
                                          _milestoneController.milestones[index]
                                              .responsible.displayName,
                                          style: TextStyleHelper.caption(
                                                  color: Theme.of(context)
                                                      .customColors()
                                                      .onSurface
                                                      .withOpacity(0.6))
                                              .copyWith(height: 1.667)),
                                    ],
                                  ),
                                ),
                                // Icon(Icons.check_rounded)
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const ListLoadingSkeleton();
              }
            },
          ),
        ],
      ),
    );
  }
}
