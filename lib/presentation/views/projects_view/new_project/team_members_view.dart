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

import 'package:projects/domain/controllers/projects/new_project/new_project_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/project_detailed/custom_appbar.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:projects/presentation/views/projects_view/widgets/search_bar.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class TeamMembersSelectionView extends StatelessWidget {
  const TeamMembersSelectionView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewProjectController>();
    var usersDataSource = Get.find<UsersDataSource>();

    usersDataSource.multipleSelectionEnabled = true;
    controller.multipleSelectionEnabled = true;
    controller.setupUsersSelection();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
        title: TeamMembersSelectionHeader(
          controller: controller,
          title: 'Add team membres',
        ),
        bottom: TeamMembersSearchBar(controller: usersDataSource),
      ),
      body: Obx(
        () {
          if (usersDataSource.loaded.isTrue &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.isFalse) {
            return UsersDefault(
              selfUserItem: controller.selfUserItem,
              usersDataSource: usersDataSource,
              onTapFunction: controller.selectTeamMember,
            );
          }
          if (usersDataSource.nothingFound.isTrue) {
            return NothingFound();
          }
          if (usersDataSource.loaded.isTrue &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.isTrue) {
            return UsersSearchResult(
              usersDataSource: usersDataSource,
              onTapFunction: controller.selectTeamMember,
            );
          }
          return ListLoadingSkeleton();
        },
      ),
    );
  }
}

class TeamMembersSelectionHeader extends StatelessWidget {
  const TeamMembersSelectionHeader({
    Key key,
    @required this.title,
    @required this.controller,
  }) : super(key: key);

  final String title;
  final NewProjectController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyleHelper.headline6(
                          color: Theme.of(context).customColors().onSurface),
                    ),
                  ),
                  Obx(
                    () {
                      if (controller.selectedTeamMembers.isNotEmpty) {
                        return Expanded(
                          child: Text(
                            '${controller.selectedTeamMembers.length} person',
                            style: TextStyleHelper.caption(
                                color:
                                    Theme.of(context).customColors().onSurface),
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
            Obx(
              () {
                if (controller.selectedTeamMembers.isNotEmpty) {
                  return InkWell(
                    onTap: () {
                      controller.confirmTeamMembers();
                    },
                    child: Icon(
                      Icons.check,
                      color: Colors.blue,
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TeamMembersSearchBar extends StatelessWidget {
  const TeamMembersSearchBar({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final UsersDataSource controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(left: 16, right: 20, bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: UsersSearchBar(controller: controller),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            height: 24,
            width: 24,
            child: InkWell(
              onTap: () {
                Get.toNamed('GroupMembersSelectionView');
              },
              child: AppIcon(
                icon: SvgIcons.preferences,
                color: Theme.of(context).customColors().primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
