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
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/status_button.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/info_tile.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/discussions/widgets/discussion_status_BS.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

class DiscussionOverview extends StatelessWidget {
  final DiscussionItemController controller;
  const DiscussionOverview({
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
          return SmartRefresher(
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 72),
                  child: Text('DISCUSSION',
                      style: TextStyleHelper.overline(
                          color: Theme.of(context)
                              .customColors()
                              .onBackground
                              .withOpacity(0.6))),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 72, right: 16),
                    child: Text(discussion.title,
                        style: TextStyleHelper.headline6(
                            color:
                                Theme.of(context).customColors().onSurface))),
                const SizedBox(height: 22),
                Obx(() => Align(
                      // otherwise it will take up the entire width
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 72, right: 16),
                        child: StatusButton(
                          text: controller.status.value == 1
                              ? 'Archived'
                              : 'Open',
                          onPressed: () async {
                            await showsDiscussionStatusesBS(
                              context: context,
                              controller: controller,
                            );
                          },
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
                InfoTile(
                    caption: 'Description:',
                    icon: AppIcon(
                        icon: SvgIcons.description,
                        color: const Color(0xff707070)),
                    subtitleWidget: ReadMoreText(discussion.text,
                        trimLines: 3,
                        colorClickableText: Colors.pink,
                        style: TextStyleHelper.body1,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        moreStyle: TextStyleHelper.body2(
                            color: Theme.of(context).customColors().links),
                        lessStyle: TextStyleHelper.body2(color: Colors.pink))),
                const SizedBox(height: 21),
                InfoTile(
                    icon: AppIcon(
                        icon: SvgIcons.project, color: const Color(0xff707070)),
                    caption: 'Project:',
                    subtitle: discussion.project.title,
                    subtitleStyle: TextStyleHelper.subtitle1(
                        color: Theme.of(context).customColors().links)),
                if (discussion.created != null) const SizedBox(height: 20),
                if (discussion.created != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.start_date,
                          color: const Color(0xff707070)),
                      caption: 'Creation date:',
                      subtitle: formatedDate(discussion.created)),
                if (discussion.createdBy != null) const SizedBox(height: 20),
                if (discussion.createdBy != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.start_date,
                          color: const Color(0xff707070)),
                      caption: 'Created by:',
                      subtitle: discussion.createdBy.displayName),
              ],
            ),
          );
        }
      },
    );
  }
}
