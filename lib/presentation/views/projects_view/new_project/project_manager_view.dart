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
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/presentation/shared/widgets/users_list.dart';

class ProjectManagerSelectionView extends StatelessWidget {
  ProjectManagerSelectionView({Key? key}) : super(key: key);

  final usersDataSource = Get.find<UsersDataSource>();
  final platformController = Get.find<PlatformController>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments ?? Get.arguments;
    final controller = args['controller'] as BaseProjectEditorController;
    final previousPage = args['previousPage'] as String?;

    controller.selectionMode = UserSelectionMode.Single;
    usersDataSource.selectionMode = UserSelectionMode.Single;
    controller.setupUsersSelection();

    return Scaffold(
      backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
      appBar: StyledAppBar(
        titleText: tr('selectPM'),
        previousPageTitle: previousPage,
        backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
        bottom: SearchField(
          controller: usersDataSource.searchInputController,
          hintText: tr('usersSearch'),
          textInputAction: TextInputAction.search,
          onClearPressed: usersDataSource.clearSearch,
          onChanged: usersDataSource.searchUsers,
          onSubmitted: usersDataSource.searchUsers,
        ),
      ),
      body: StyledSmartRefresher(
        enablePullDown: false,
        enablePullUp: usersDataSource.pullUpEnabled,
        controller: usersDataSource.refreshController,
        onLoading: usersDataSource.onLoading,
        child: Obx(
          () {
            if (controller.usersLoaded.value &&
                usersDataSource.usersWithoutVisitors.isNotEmpty &&
                !usersDataSource.isSearchResult.value) {
              return UsersStyledList(
                selfUserItem: controller.selfUserItem,
                onTapFunction: controller.changePMSelection,
                users: usersDataSource.usersWithoutVisitors
                    .where(
                        (element) => element.portalUser.id != controller.selfUserItem.portalUser.id)
                    .toList(),
              );
            }
            if (usersDataSource.nothingFound.value) {
              return const NothingFound();
            }
            if (usersDataSource.loaded.value && usersDataSource.isSearchResult.value) {
              if (usersDataSource.usersWithoutVisitors.isNotEmpty)
                return UsersSimpleList(
                  onTapFunction: controller.changePMSelection,
                  users: usersDataSource.usersWithoutVisitors
                      .where((element) =>
                          element.portalUser.id != controller.selfUserItem.portalUser.id)
                      .toList(),
                );
              else
                return const NothingFound();
            }
            return const ListLoadingSkeleton();
          },
        ),
      ),
    );
  }
}
