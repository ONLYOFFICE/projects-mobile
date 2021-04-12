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

import 'package:projects/domain/controllers/projects/new_project_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/project_detailed/custom_appbar.dart';
import 'package:projects/presentation/views/projects_view/widgets/header.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';
import 'package:projects/presentation/views/projects_view/widgets/search_bar.dart';

class ProjectManagerSelectionView extends StatelessWidget {
  const ProjectManagerSelectionView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewProjectController>();

    controller.setupPMSelection();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
        title: CustomHeaderWithoutButton(
          title: 'Select project manager',
        ),
        bottom: SearchBar(controller: controller),
      ),
      body: Obx(
        () {
          if (controller.usersLoaded.isTrue &&
              controller.searchResult.isEmpty &&
              controller.nothingFound.isFalse) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('Me', style: TextStyleHelper.body2()),
                ),
                SizedBox(height: 26),
                PortalUserItem(
                  onTapFunction: controller.changePMSelection,
                  userController: controller.selfUserItem,
                ),
                SizedBox(height: 26),
                Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('Users', style: TextStyleHelper.body2()),
                ),
                SizedBox(height: 26),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (c, i) => PortalUserItem(
                        userController: controller.allUsers[i],
                        onTapFunction: controller.changePMSelection),
                    itemExtent: 65.0,
                    itemCount: controller.allUsers.length,
                  ),
                ),
              ],
            );
          }
          if (controller.nothingFound.isTrue) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Not found',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }
          if (controller.usersLoaded.isTrue &&
              controller.searchResult.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (c, i) => PortalUserItem(
                        userController: controller.searchResult[i],
                        onTapFunction: controller.changePMSelection),
                    itemExtent: 65.0,
                    itemCount: controller.searchResult.length,
                  ),
                )
              ],
            );
          }
          return ListLoadingSkeleton();
        },
      ),
    );
  }
}
