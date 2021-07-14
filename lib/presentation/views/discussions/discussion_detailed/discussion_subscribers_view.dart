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
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DiscussionSubscribersView extends StatelessWidget {
  final DiscussionItemController controller;
  const DiscussionSubscribersView({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.loaded.isFalse)
          return const ListLoadingSkeleton();
        else {
          var discussion = controller.discussion.value;
          return Stack(
            children: [
              SmartRefresher(
                controller: controller.refreshController,
                onRefresh: controller.onRefresh,
                child: ListView.separated(
                  itemCount: discussion.subscribers.length,
                  padding:
                      const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 24);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CustomNetworkImage(
                              image: discussion.subscribers[index].avatar ??
                                  discussion.subscribers[index].avatarMedium ??
                                  discussion.subscribers[index].avatarSmall,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                discussion.subscribers[index].displayName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyleHelper.subtitle1(
                                    color: Get.theme.colors().onSurface),
                              ),
                              if (discussion.subscribers[index]?.title != null)
                                Text(discussion.subscribers[index]?.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyleHelper.caption(
                                        color: Get.theme
                                            .colors()
                                            .onSurface
                                            .withOpacity(0.6))),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 24),
                  child: StyledFloatingActionButton(
                    onPressed: () {},
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
