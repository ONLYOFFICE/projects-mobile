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
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/domain/controllers/milestones/milestones_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

class SelectMilestoneView extends StatelessWidget {
  final selectedId;
  const SelectMilestoneView({
    Key key,
    this.selectedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _milestoneController = Get.find<MilestonesController>();

    _milestoneController.getAllMilestones();

    var controller = Get.arguments['controller'];

    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor:
          platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        titleText: tr('selectMilestone'),
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
      ),
      body: Column(
        children: [
          Obx(
            () {
              if (_milestoneController.loaded.value == true) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: _milestoneController.milestones.length + 1,
                    padding: const EdgeInsets.only(bottom: 16),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        indent: 16,
                        endIndent: 16,
                        height: 1,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return _None(
                          onTap: controller.changeMilestoneSelection,
                          isSelected: controller.newMilestoneId == null,
                        );
                      }
                      return _MilestoneSelectionTile(
                        onTap: () {
                          return controller.changeMilestoneSelection(
                            id: _milestoneController.milestones[index - 1].id,
                            title: _milestoneController
                                .milestones[index - 1].title,
                          );
                        },
                        milestone: _milestoneController.milestones[index - 1],
                        isSelected:
                            _milestoneController.milestones[index - 1].id ==
                                controller.newMilestoneId,
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

class _None extends StatelessWidget {
  const _None({
    Key key,
    @required this.isSelected,
    @required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 26),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(tr('none'),
                style: TextStyleHelper.subtitle1(
                    color: Get.theme.colors().onSurface)),
            if (isSelected)
              Icon(Icons.check_rounded,
                  color: Get.theme.colors().onBackground.withOpacity(0.6))
          ],
        ),
      ),
    );
  }
}

class _MilestoneSelectionTile extends StatelessWidget {
  const _MilestoneSelectionTile({
    Key key,
    @required this.milestone,
    @required this.isSelected,
    @required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final Function() onTap;
  final Milestone milestone;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone.title,
                    style: TextStyleHelper.projectTitle,
                  ),
                  Text(milestone.responsible.displayName,
                      style: TextStyleHelper.caption(
                              color:
                                  Get.theme.colors().onSurface.withOpacity(0.6))
                          .copyWith(height: 1.667)),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded,
                  color: Get.theme.colors().onBackground.withOpacity(0.6))
          ],
        ),
      ),
    );
  }
}
