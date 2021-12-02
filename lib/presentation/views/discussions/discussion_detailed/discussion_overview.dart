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
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/internal/utils/html_parser.dart';
import 'package:projects/presentation/shared/status_button.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/info_tile.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

class DiscussionOverview extends StatelessWidget {
  final DiscussionItemController? controller;
  const DiscussionOverview({
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
          return SmartRefresher(
            controller: controller!.refreshController,
            onRefresh: controller!.onRefresh,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 72),
                  child: Text(tr('discussion').toUpperCase(),
                      style: TextStyleHelper.overline(
                          color: Get.theme.colors().onBackground.withOpacity(0.6))),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 72, right: 16),
                    child: Text(discussion.title!,
                        style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface))),
                const SizedBox(height: 22),
                _DiscussionStatus(controller: controller),
                const SizedBox(height: 16),
                InfoTile(
                  caption: '${tr('description')}:',
                  icon: const AppIcon(icon: SvgIcons.description, color: Color(0xff707070)),
                  subtitleWidget: ReadMoreText(
                    parseHtml(discussion.text),
                    trimLines: 3,
                    colorClickableText: Colors.pink,
                    style: TextStyleHelper.body1,
                    trimMode: TrimMode.Line,
                    delimiter: ' ',
                    trimCollapsedText: tr('showMore'),
                    trimExpandedText: tr('showLess'),
                    moreStyle: TextStyleHelper.body2(color: Get.theme.colors().links),
                    lessStyle: TextStyleHelper.body2(color: Get.theme.colors().links),
                  ),
                ),
                const SizedBox(height: 21),
                InfoTile(
                  icon: const AppIcon(icon: SvgIcons.project, color: Color(0xff707070)),
                  caption: '${tr('project')}:',
                  subtitle: discussion.project!.title,
                  subtitleStyle: TextStyleHelper.subtitle1(
                    color: Get.theme.colors().links,
                  ),
                  onTap: controller!.toProjectOverview,
                ),
                if (discussion.created != null) const SizedBox(height: 20),
                if (discussion.created != null)
                  InfoTile(
                    caption: '${tr('creationDate')}:',
                    subtitle: formatedDate(discussion.created!),
                  ),
                if (discussion.createdBy != null) const SizedBox(height: 20),
                if (discussion.createdBy != null)
                  InfoTile(
                    caption: '${tr('createdBy')}:',
                    subtitle: discussion.createdBy!.displayName,
                  ),
                const SizedBox(height: 100),
              ],
            ),
          );
        }
      },
    );
  }
}

class _DiscussionStatus extends StatelessWidget {
  const _DiscussionStatus({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final DiscussionItemController? controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Align(
        // otherwise it will take up the entire width
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 72, right: 16),
          child: StatusButton(
            canEdit: controller!.discussion.value.canEdit,
            text: controller!.status.value == 1 ? tr('archived') : tr('open'),
            onPressed: () async => controller!.tryChangingStatus(context),
          ),
        ),
      ),
    );
  }
}
