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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/detailed_project_controller.dart';
import 'package:projects/presentation/shared/platform_icons_ext.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/info_tile.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

class ProjectOverview extends StatelessWidget {
  final ProjectDetailsController projectController;
  final TabController? tabController;

  const ProjectOverview({
    Key? key,
    required this.projectController,
    this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (projectController.loaded.value == true) {
          return StyledSmartRefresher(
            controller: RefreshController(),
            onRefresh: projectController.refreshData,
            child: ListView(
              children: [
                const SizedBox(height: 26),
                Obx(
                  () => InfoTile(
                    caption: tr('project'),
                    captionStyle: TextStyleHelper.overline(
                        color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                    icon: const AppIcon(icon: SvgIcons.project, color: Color(0xff707070)),
                    subtitle: projectController.projectTitleText.value,
                    subtitleStyle: TextStyleHelper.headline7(
                      color: Theme.of(context).colors().onBackground,
                    ),
                    privateIconVisible: projectController.isPrivate.value,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 72),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: ProjectStatusButton(projectController: projectController)),
                ),
                const SizedBox(height: 25),
                if (projectController.descriptionText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: InfoTile(
                      caption: tr('description'),
                      captionStyle: TextStyleHelper.caption(
                          color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                      icon: const AppIcon(icon: SvgIcons.description, color: Color(0xff707070)),
                      subtitleWidget: ReadMoreText(
                        projectController.descriptionText.value,
                        trimLines: 3,
                        colorClickableText: Colors.pink,
                        style: TextStyleHelper.body1(),
                        trimMode: TrimMode.Line,
                        delimiter: '\n',
                        trimCollapsedText: tr('showMore'),
                        trimExpandedText: tr('showLess'),
                        moreStyle: TextStyleHelper.body2(color: Theme.of(context).colors().links),
                        lessStyle: TextStyleHelper.body2(color: Theme.of(context).colors().links),
                      ),
                    ),
                  ),
                Obx(() => InfoTile(
                      icon: const AppIcon(icon: SvgIcons.user, color: Color(0xff707070)),
                      caption: tr('projectManager'),
                      captionStyle: TextStyleHelper.caption(
                          color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                      subtitle: projectController.managerText.value,
                      subtitleStyle:
                          TextStyleHelper.subtitle1(color: Theme.of(context).colors().onSurface),
                    )),
                const SizedBox(height: 20),
                Obx(
                  () => InkWell(
                    onTap: () {
                      tabController!.animateTo(5);
                    },
                    child: InfoTileWithButton(
                      icon: const AppIcon(icon: SvgIcons.users, color: Color(0xff707070)),
                      onTapFunction: () {
                        tabController!.animateTo(5);
                      },
                      caption: tr('team'),
                      captionStyle: TextStyleHelper.caption(
                          color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                      iconData: PlatformIcons(context).rightChevron,
                      subtitle: plural(
                          'members', projectController.projectTeamDataSource!.usersList.length),
                      subtitleStyle:
                          TextStyleHelper.subtitle1(color: Theme.of(context).colors().onSurface),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => InfoTile(
                    icon: const AppIcon(icon: SvgIcons.calendar, color: Color(0xff707070)),
                    caption: tr('creationDate'),
                    captionStyle: TextStyleHelper.caption(
                        color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                    subtitle: projectController.creationDateText.value)),
                const SizedBox(height: 20),
                Obx(() {
                  if (projectController.tagsText.value.isNotEmpty)
                    return InfoTile(
                        icon: const AppIcon(icon: SvgIcons.tag, color: Color(0xff707070)),
                        caption: tr('tags'),
                        captionStyle: TextStyleHelper.caption(
                            color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                        subtitle: projectController.tagsText.value);
                  return const SizedBox();
                })
              ],
            ),
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}

class ProjectStatusButton extends StatelessWidget {
  final BaseProjectEditorController projectController;

  const ProjectStatusButton({Key? key, required this.projectController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canEdit = projectController.projectData!.canEdit!;
    return PlatformTextButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onPressed:
          canEdit ? () => showStatuses(context: context, itemController: projectController) : null,
      material: (_, __) => MaterialTextButtonData(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>((_) {
        return canEdit
            ? const Color(0xff81C4FF).withOpacity(0.2)
            : Theme.of(context).colors().bgDescription;
      }), side: MaterialStateProperty.resolveWith((_) {
        return const BorderSide(color: Colors.transparent, width: 0);
      }))),
      cupertino: (_, __) => CupertinoTextButtonData(
          color: canEdit
              ? const Color(0xff81C4FF).withOpacity(0.2)
              : Theme.of(context).colors().bgDescription),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Obx(
              () => Text(
                projectController.statusText.value,
                style: TextStyleHelper.subtitle2(
                  color: canEdit
                      ? Theme.of(context).colors().primary
                      : Theme.of(context).colors().onBackground.withOpacity(0.75),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          if (canEdit)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                PlatformIcons(context).downChevron,
                color: Theme.of(context).colors().primary,
                size: 19,
              ),
            )
        ],
      ),
    );
  }
}
