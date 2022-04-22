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
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/users_from_groups.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';

class SelectDiscussionSubscribers extends StatelessWidget {
  const SelectDiscussionSubscribers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usersDataSource = Get.find<UsersDataSource>();
    final args = ModalRoute.of(context)!.settings.arguments ?? Get.arguments;
    final controller = args['controller'] as DiscussionActionsController;

    controller.setupSubscribersSelection();

    final platformController = Get.find<PlatformController>();

    return WillPopScope(
      onWillPop: () async {
        controller.leaveSubscribersSelectionView();
        return false;
      },
      child: Scaffold(
        backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
        appBar: StyledAppBar(
          backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,

          backButtonIcon: Icon(PlatformIcons(context).back),

          title: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('selectSubscribers'),
                  style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface),
                ),
                if (controller.subscribers.isNotEmpty)
                  Text(plural('selected', controller.subscribers.length),
                      style: TextStyleHelper.caption(color: Get.theme.colors().onSurface))
              ],
            ),
          ),
          onLeadingPressed: controller.leaveSubscribersSelectionView,
          actions: [
            PlatformIconButton(
              onPressed: controller.confirmSubscribersSelection,
              icon: Icon(PlatformIcons(context).checkMark),
            ),
          ],
          // bottom: CustomSearchBar(controller: controller),
          bottom: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(() => Expanded(
                    child: SearchField(
                      hintText: tr('usersSearch'),
                      onSubmitted: usersDataSource.searchUsers,
                      showClearIcon: usersDataSource.isSearchResult.value == true,
                      onChanged: usersDataSource.searchUsers,
                      onClearPressed: controller.clearUserSearch,
                      controller: controller.userSearchController,
                    ),
                  )),
              PlatformIconButton(
                padding: EdgeInsets.zero,
                onPressed: () => Get.find<NavigationController>().toScreen(
                  const UsersFromGroups(),
                  arguments: {'controller': controller},
                  transition: Transition.cupertinoDialog,
                  fullscreenDialog: true,
                  page: '/UsersFromGroups',
                ),
                icon: const AppIcon(icon: SvgIcons.preferences),
              )
            ],
          ),
        ),
        body: Obx(
          () {
            if (usersDataSource.loaded.value == true &&
                usersDataSource.usersList.isNotEmpty &&
                usersDataSource.isSearchResult.value == false) {
              return StyledSmartRefresher(
                enablePullDown: false,
                controller: usersDataSource.refreshController,
                onLoading: usersDataSource.onLoading,
                enablePullUp: usersDataSource.pullUpEnabled,
                child: ListView.separated(
                    itemCount: usersDataSource.usersList.length,
                    separatorBuilder: (_, i) => !platformController.isMobile
                        ? const StyledDivider(leftPadding: 72)
                        : const SizedBox(),
                    itemBuilder: (BuildContext context, int index) {
                      return PortalUserItem(
                        userController: usersDataSource.usersList[index],
                        onTapFunction: (value) => {
                          controller.addSubscriber(usersDataSource.usersList[index],
                              fromUsersDataSource: true)
                        },
                      );
                    }),
              );
            }
            if (usersDataSource.nothingFound.value == true) {
              return const NothingFound();
            }
            if (usersDataSource.loaded.value == true &&
                usersDataSource.usersList.isNotEmpty &&
                usersDataSource.isSearchResult.value == true) {
              return UsersSearchResult(
                usersDataSource: usersDataSource,
                onTapFunction: controller.addSubscriber,
              );
            }
            return const ListLoadingSkeleton();
          },
        ),
      ),
    );
  }
}
