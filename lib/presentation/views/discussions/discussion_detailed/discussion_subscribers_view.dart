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
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/presentation/views/profile/profile_screen.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';

class DiscussionSubscribersView extends StatelessWidget {
  final DiscussionItemController? controller;
  const DiscussionSubscribersView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller!.loaded.value == false)
          return const ListLoadingSkeleton();
        else {
          final discussion = controller!.discussion.value;
          return Stack(
            children: [
              StyledSmartRefresher(
                controller: controller!.subscribersRefreshController,
                onRefresh: controller!.onRefresh,
                child: ListView.separated(
                  itemCount: discussion.subscribers!.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final userController =
                        PortalUserItemController(portalUser: discussion.subscribers![index]);
                    return PortalUserItem(
                        userController: userController,
                        onTapFunction: (value) => {
                              Get.find<NavigationController>().toScreen(const ProfileScreen(),
                                  arguments: {'controller': userController})
                            });
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 24),
                  child: Obx(
                    () => Visibility(
                      visible: controller!.fabIsVisible.value,
                      child: StyledFloatingActionButton(
                        onPressed: () => controller!.toSubscribersManagingScreen(context),
                        child: AppIcon(
                          icon: SvgIcons.add_fab,
                          color: Get.theme.colors().onPrimarySurface,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }
}
