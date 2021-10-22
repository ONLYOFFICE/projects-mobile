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
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectTeamResponsibleSelectionView extends StatelessWidget {
  const ProjectTeamResponsibleSelectionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.arguments['controller']..setupResponsibleSelection();

    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor:
          platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        titleText: tr('selectResponsible'),
        bottom: SearchField(
          hintText: tr('usersSearch'),
          onSubmitted: (value) => controller.teamController.searchUsers(value),
          onChanged: (value) => controller.teamController.searchUsers(value),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: controller.confirmResponsiblesSelection)
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.leaveResponsiblesSelectionView,
        ),
      ),
      body: Obx(
        () {
          if (controller.teamController.loaded.value == true &&
              controller.teamController.usersList.isNotEmpty &&
              controller.teamController.isSearchResult.value == false) {
            return SmartRefresher(
              enablePullDown: false,
              enablePullUp: controller.teamController.pullUpEnabled,
              controller: controller.teamController.refreshController,
              onLoading: controller.teamController.onLoading,
              child: ListView(
                children: <Widget>[
                  Column(children: [
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (c, i) => PortalUserItem(
                          userController:
                              controller.teamController.usersList[i],
                          onTapFunction: controller.addResponsible),
                      itemExtent: 65.0,
                      itemCount: controller.teamController.usersList.length,
                    )
                  ]),
                ],
              ),
            );
          }
          if (controller.teamController.nothingFound.value == true) {
            return Column(children: [const NothingFound()]);
          }
          if (controller.teamController.loaded.value == true &&
              controller.teamController.searchResult.isNotEmpty &&
              controller.teamController.isSearchResult.value == true) {
            return SmartRefresher(
              enablePullDown: false,
              enablePullUp: controller.teamController.pullUpEnabled,
              controller: controller.teamController.refreshController,
              onLoading: controller.teamController.onLoading,
              child: ListView(
                children: <Widget>[
                  Column(children: [
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (c, i) => PortalUserItem(
                          userController:
                              controller.teamController.searchResult[i],
                          onTapFunction: controller.addResponsible),
                      itemExtent: 65.0,
                      itemCount: controller.teamController.searchResult.length,
                    )
                  ]),
                ],
              ),
            );
          }
          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}
