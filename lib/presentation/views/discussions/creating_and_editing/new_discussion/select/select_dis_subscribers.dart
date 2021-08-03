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
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/users_from_groups.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectDiscussionSubscribers extends StatelessWidget {
  const SelectDiscussionSubscribers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usersDataSource = Get.find<UsersDataSource>();
    DiscussionActionsController controller = Get.arguments['controller'];

    controller.setupSubscribersSelection();

    return Scaffold(
      appBar: StyledAppBar(
        // titleText: 'Select subscribers',
        backButtonIcon: Get.put(PlatformController()).isMobile
            ? const Icon(Icons.arrow_back_rounded)
            : const Icon(Icons.close),
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr('selectSubscribers')),
              if (controller.subscribers.isNotEmpty)
                Text(plural('selected', controller.subscribers.length),
                    style: TextStyleHelper.caption())
            ],
          ),
        ),
        onLeadingPressed: controller.leaveSubscribersSelectionView,
        actions: [
          IconButton(
              onPressed: controller.confirmSubscribersSelection,
              icon: const Icon(Icons.done))
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
                    onClearPressed: controller.clearUserSearch,
                    controller: controller.userSearchController,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.5, right: 16),
              child: InkResponse(
                onTap: () => Get.find<NavigationController>()
                    .navigateToFullscreen(const UsersFromGroups(),
                        arguments: {'controller': controller}),
                child: AppIcon(icon: SvgIcons.preferences),
              ),
            )
          ],
        ),
      ),
      body: Obx(
        () {
          if (usersDataSource.loaded.value == true &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.value == false) {
            return SmartRefresher(
              enablePullDown: false,
              controller: usersDataSource.refreshController,
              onLoading: usersDataSource.onLoading,
              enablePullUp: usersDataSource.pullUpEnabled,
              child: ListView.separated(
                itemCount: usersDataSource.usersList.length,
                padding: const EdgeInsets.symmetric(vertical: 13),
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 24);
                },
                itemBuilder: (BuildContext context, int index) {
                  return Obx(
                    () => CheckboxListTile(
                      value:
                          usersDataSource.usersList[index].isSelected == true,
                      onChanged: (value) {
                        controller.addSubscriber(
                          usersDataSource.usersList[index],
                          fromUsersDataSource: true,
                        );
                      },
                      contentPadding: const EdgeInsets.only(left: 16, right: 9),
                      title: Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: CustomNetworkImage(
                                image: usersDataSource
                                        .usersList[index].portalUser.avatar ??
                                    usersDataSource.usersList[index].portalUser
                                        .avatarMedium ??
                                    usersDataSource.usersList[index].portalUser
                                        .avatarSmall,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  usersDataSource.usersList[index].displayName,
                                  maxLines: 2,
                                  style: TextStyleHelper.subtitle1(
                                      color: Get.theme.colors().onSurface),
                                ),
                                if (usersDataSource
                                        .usersList[index].portalUser.title !=
                                    null)
                                  Text(
                                    usersDataSource
                                        .usersList[index].portalUser.title,
                                    maxLines: 2,
                                    style: TextStyleHelper.caption(
                                        color: Get.theme
                                            .colors()
                                            .onSurface
                                            .withOpacity(0.6)),
                                  ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
    );
  }
}
