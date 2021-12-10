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
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/internal/utils/name_formatter.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/default_avatar.dart';

class DiscussionTile extends StatelessWidget {
  final Discussion discussion;
  final Function()? onTap;

  const DiscussionTile({
    Key? key,
    required this.discussion,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _Image(
              image: discussion.createdBy!.avatar ??
                  discussion.createdBy!.avatarMedium ??
                  discussion.createdBy!.avatarSmall,
            ),
            const SizedBox(width: 16),
            _DiscussionInfo(discussion: discussion),
            const SizedBox(width: 11.33),
            _CommentsCount(commentsCount: discussion.commentsCount),
          ],
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String? image;
  const _Image({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: CustomNetworkImage(
          image: image,
          defaultImage: const DefaultAvatar(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _DiscussionInfo extends StatelessWidget {
  final Discussion? discussion;
  const _DiscussionInfo({
    Key? key,
    required this.discussion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            discussion!.title!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyleHelper.projectTitle.copyWith(
              color: discussion!.status == 1
                  ? Get.theme.colors().onBackground.withOpacity(0.6)
                  : null,
            ),
          ),
          RichText(
            text: TextSpan(
              style: TextStyleHelper.caption(
                  color: Get.theme.colors().onSurface.withOpacity(0.6)),
              children: [
                if (discussion!.status == 1)
                  TextSpan(
                      text: '${tr('archived')} • ',
                      style: TextStyleHelper.status(
                          color: Get.theme.colors().onBackground)),
                TextSpan(text: formatedDate(discussion!.created!)),
                const TextSpan(text: ' • '),
                TextSpan(
                  text: NameFormatter.formateName(discussion!.createdBy!),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentsCount extends StatelessWidget {
  final int? commentsCount;
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
            color: Get.theme.colors().onBackground.withOpacity(0.6)),
        const SizedBox(width: 5.33),
        Text(commentsCount.toString(),
            style: TextStyleHelper.body2(
                color: Get.theme.colors().onBackground.withOpacity(0.6))),
      ],
    );
  }
}
