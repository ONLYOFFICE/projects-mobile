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
import 'package:projects/internal/utils/name_formatter.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/default_avatar.dart';

class DiscussionTile extends StatelessWidget {
  final Function()? onTap;
  final DiscussionItemController controller;

  const DiscussionTile({
    Key? key,
    required this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final discussion = controller.discussion;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 72,
        child: Row(
          children: [
            const SizedBox(width: 16),
            _Image(avatarUrl: controller.avatarUrl),
            const SizedBox(width: 16),
            Expanded(child: _DiscussionInfo(controller: controller)),
            const SizedBox(width: 8),
            _CommentsCount(commentsCount: discussion.value.commentsCount ?? 0),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final Rx<String> avatarUrl;
  const _Image({
    Key? key,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: ClipOval(
        child: Obx(
          () => CustomNetworkImage(
            image: avatarUrl.value,
            defaultImage: const DefaultAvatar(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _DiscussionInfo extends StatelessWidget {
  final DiscussionItemController controller;
  const _DiscussionInfo({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => Text(
            controller.discussion.value.title!.trim(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyleHelper.subtitle1(
                color: controller.discussion.value.status == 1
                    ? Theme.of(context).colors().onBackground.withOpacity(0.6)
                    : null),
          ),
        ),
        Obx(
          () {
            final discussion = controller.discussion.value;
            return RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              text: TextSpan(
                style: TextStyleHelper.caption(
                    color: Theme.of(context).colors().onSurface.withOpacity(0.6)),
                children: [
                  if (controller.status.value == 1)
                    TextSpan(
                        text: '${tr('archived')} • ',
                        style:
                            TextStyleHelper.status(color: Theme.of(context).colors().onBackground)),
                  TextSpan(text: formatedDate(discussion.created!)),
                  const TextSpan(text: ' • '),
                  TextSpan(
                    text: NameFormatter.formateName(discussion.createdBy!),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CommentsCount extends StatelessWidget {
  final int commentsCount;
  const _CommentsCount({
    Key? key,
    required this.commentsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppIcon(
            icon: SvgIcons.comments,
            color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
        const SizedBox(width: 5.33),
        Text(commentsCount.toString(),
            style: TextStyleHelper.body2(
                color: Theme.of(context).colors().onBackground.withOpacity(0.6))),
      ],
    );
  }
}
