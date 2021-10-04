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
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:projects/presentation/shared/widgets/info_tile.dart';
import 'package:projects/domain/controllers/projects/detailed_project/detailed_project_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';
import 'package:readmore/readmore.dart';

class ProjectOverview extends StatelessWidget {
  final ProjectDetailsController projectController;
  final TabController tabController;

  const ProjectOverview({
    Key key,
    @required this.projectController,
    this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var projectController = Get.find<ProjectDetailsController>();

    return Obx(
      () {
        if (projectController.loaded.value == true) {
          return ListView(
            children: [
              const SizedBox(height: 26),
              Obx(
                () => InfoTile(
                  caption: tr('project').toUpperCase(),
                  subtitle: projectController.projectTitleText.value,
                  subtitleStyle: TextStyleHelper.headline7(
                    color: Get.theme.colors().onBackground,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ProjectStatusButton(projectController: projectController),
              const SizedBox(height: 20),
              if (projectController.descriptionText != null &&
                  projectController.descriptionText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InfoTile(
                    caption: tr('description'),
                    icon: AppIcon(
                        icon: SvgIcons.description,
                        color: const Color(0xff707070)),
                    subtitleWidget: ReadMoreText(
                      projectController.descriptionText.value,
                      trimLines: 3,
                      colorClickableText: Colors.pink,
                      style: TextStyleHelper.body1,
                      trimMode: TrimMode.Line,
                      delimiter: ' ',
                      trimCollapsedText: tr('showMore'),
                      trimExpandedText: tr('showLess'),
                      moreStyle: TextStyleHelper.body2(
                          color: Get.theme.colors().links),
                      lessStyle: TextStyleHelper.body2(
                          color: Get.theme.colors().links),
                    ),
                  ),
                ),
              Obx(() => InfoTile(
                    icon: AppIcon(
                        icon: SvgIcons.user, color: const Color(0xff707070)),
                    caption: tr('projectManager'),
                    subtitle: projectController.managerText.value,
                    subtitleStyle: TextStyleHelper.subtitle1(
                        color: Get.theme.colors().onSurface),
                  )),
              const SizedBox(height: 20),
              Obx(
                () => InkWell(
                  onTap: () {
                    tabController.animateTo(5);
                  },
                  child: InfoTileWithButton(
                    icon: AppIcon(
                        icon: SvgIcons.users, color: const Color(0xff707070)),
                    onTapFunction: () {
                      tabController.animateTo(5);
                    },
                    caption: tr('team'),
                    iconData: Icons.arrow_forward_ios_rounded,
                    subtitle: plural(
                        'members', projectController.teamMembersCount.value),
                    subtitleStyle: TextStyleHelper.subtitle1(
                        color: Get.theme.colors().onSurface),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.calendar, color: const Color(0xff707070)),
                  caption: tr('creationDate'),
                  subtitle: projectController.creationDateText.value)),
              const SizedBox(height: 20),
              Obx(() => InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.tag, color: const Color(0xff707070)),
                  caption: tr('tags'),
                  subtitle: projectController.tagsText.value)),
            ],
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}

class ProjectStatusButton extends StatelessWidget {
  final projectController;

  const ProjectStatusButton({Key key, @required this.projectController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: omit_local_variable_types
    bool canEdit = projectController.projectData.canEdit;
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton(
            onPressed: canEdit
                ? () => {
                      showsStatusesBS(
                          context: context, itemController: projectController),
                    }
                : null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>((_) {
                if (canEdit)
                  return const Color(0xff81C4FF).withOpacity(0.2);
                else
                  return Get.theme.colors().bgDescription;
              }),
              side: MaterialStateProperty.resolveWith((_) {
                return const BorderSide(color: Colors.transparent, width: 0);
              }),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5),
                    child: Obx(
                      () => Text(
                        projectController.statusText.value,
                        style: TextStyleHelper.subtitle2(
                          color: canEdit
                              ? Get.theme.colors().primary
                              : Get.theme
                                  .colors()
                                  .onBackground
                                  .withOpacity(0.75),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                if (canEdit)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Get.theme.colors().primary,
                      size: 19,
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
