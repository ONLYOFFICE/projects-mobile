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
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/profile/profile_screen.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';

class ProjectTeamView extends StatelessWidget {
  final ProjectDetailed? projectDetailed;

  final fabAction;

  const ProjectTeamView({
    Key? key,
    required this.projectDetailed,
    required this.fabAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var projectTeamDataSource = Get.find<ProjectTeamController>()
      ..setup(projectDetailed: projectDetailed)
      ..getTeam();

    return Stack(
      children: [
        _Content(projectTeamDataSource: projectTeamDataSource),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 24),
            child: Obx(
              () => Visibility(
                visible: projectTeamDataSource.fabIsVisible.value,
                child: StyledFloatingActionButton(
                  onPressed: fabAction as Function(),
                  child: AppIcon(
                    icon: SvgIcons.fab_user,
                    color: Get.theme.colors().onPrimarySurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.projectTeamDataSource,
  }) : super(key: key);

  final ProjectTeamController projectTeamDataSource;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (projectTeamDataSource.loaded.value == true) {
        return SmartRefresher(
            enablePullDown: false,
            enablePullUp: projectTeamDataSource.pullUpEnabled,
            controller: projectTeamDataSource.refreshController,
            onLoading: projectTeamDataSource.onLoading,
            child: ListView(
              children: <Widget>[
                Column(
                  children: [
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (c, i) => PortalUserItem(
                          userController: projectTeamDataSource.usersList[i],
                          onTapFunction: (value) => {
                                Get.find<NavigationController>().toScreen(
                                    const ProfileScreen(),
                                    arguments: {
                                      'portalUser': projectTeamDataSource
                                          .usersList[i].portalUser
                                    })
                              }),
                      itemExtent: 65.0,
                      itemCount: projectTeamDataSource.usersList.length,
                    )
                  ],
                ),
              ],
            ));
      }
      return const ListLoadingSkeleton();
    });
  }
}
