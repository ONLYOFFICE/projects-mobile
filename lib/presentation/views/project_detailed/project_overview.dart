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
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/project_cell_controller.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/task_detailed/overview/overview_screen.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

class ProjectOverview extends StatelessWidget {
  final ProjectCellController controller;

  const ProjectOverview({Key key, @required this.controller})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    //  return Obx(
    //   () {
    //     if (controller.loaded.isTrue) {
    String _text =
        'Aliqua id fugiat nostrud irure ex duis ea quis id quis ad et. Sunt qui esse pariatur duis deserunt mollit dolore cillum m Aliqua id fugiat nostrud irure ex duis ea quis id quis ad et. Sunt qui esse pariatur duis deserunt mollit dolore cillum m';
    return SmartRefresher(
      controller: controller.refreshController,
      onRefresh: () => controller.reloadTask(),
      child: ListView(
        children: [
          // Task(
          //   taskController: controller,
          // ),
          InfoTile(
            icon: AppIcon(icon: SvgIcons.user, color: const Color(0xff707070)),
            caption: 'Project manager:',
            subtitle: 'Sergey Petrov',
            subtitleStyle: TextStyleHelper.subtitle1(
                color: Theme.of(context).customColors().onSurface),
          ),
          const SizedBox(height: 20),
          InfoTile(
            icon: AppIcon(icon: SvgIcons.users, color: const Color(0xff707070)),
            caption: 'Team:',
            subtitle: '2 members',
            subtitleStyle: TextStyleHelper.subtitle1(
                color: Theme.of(context).customColors().onSurface),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 56, right: 32, top: 42, bottom: 42),
            child: ReadMoreText(
              _text,
              trimLines: 3,
              colorClickableText: Colors.pink,
              style: TextStyleHelper.body1,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              moreStyle: TextStyleHelper.body2(
                  color: Theme.of(context).customColors().links),
            ),
          ),
          const SizedBox(height: 20),
          InfoTile(
              icon:
                  AppIcon(icon: SvgIcons.user, color: const Color(0xff707070)),
              caption: 'Creation date:',
              subtitle: '21 Mar 2021'),
          const SizedBox(height: 20),

          InfoTile(
              icon:
                  AppIcon(icon: SvgIcons.user, color: const Color(0xff707070)),
              caption: 'Tags',
              subtitle: 'app, new task, app, new task'),
        ],
      ),
    );
    //   } else {
    //     return const Material(
    //       child: Center(child: Text('LOADING')),
    //     );
    //   }
    // },
    // );
  }
}
