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
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/domain/controllers/comments/item_controller/abstract_comment_item_controller.dart';
import 'package:projects/domain/controllers/comments/item_controller/discussion_comment_item_controller.dart';
import 'package:projects/domain/controllers/comments/item_controller/task_comment_item_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/portal_info_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/default_avatar.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_item.dart';
import 'package:projects/presentation/shared/wrappers/platform_text_button.dart';
import 'package:projects/presentation/views/task_detailed/comments/reply_comment_view.dart';

class Comment extends StatelessWidget {
  final int? taskId;
  final int? discussionId;
  final PortalComment comment;
  const Comment({
    Key? key,
    required this.comment,
    this.taskId,
    this.discussionId,
  })  : assert(discussionId == null || taskId == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!comment.inactive!) {
      CommentItemController controller;

      if (taskId != null) {
        controller = Get.put(
          TaskCommentItemController(taskId: taskId, comment: comment.obs),
          tag: comment.hashCode.toString(),
          permanent: false,
        );
      } else {
        controller = Get.put(
          DiscussionCommentItemController(
            discussionId: discussionId,
            comment: comment.obs,
          ),
          tag: comment.hashCode.toString(),
          permanent: false,
        );
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CommentAuthor(comment: comment, controller: controller),
            const SizedBox(height: 8),
            Obx(
              () => HtmlWidget(
                controller.comment?.value.commentBody?.trim() ?? '',
                textStyle: TextStyleHelper.body1(color: Get.theme.colors().onBackground),
                customStylesBuilder: (element) {
                  if (element.attributes.containsKey('style') &&
                      element.attributes['style']!.contains('color')) {
                    element.attributes['style'] = '';
                  }
                },
                factoryBuilder: () => _HTMLWidgetFactory(),
              ),
            ),
            if (comment.isResponsePermissions!)
              PlatformTextButton(
                padding: const EdgeInsets.only(top: 8),
                onPressed: () async {
                  return await Get.find<NavigationController>()
                      .toScreen(const ReplyCommentView(), arguments: {
                    'comment': controller.comment!.value,
                    'discussionId': discussionId,
                    'taskId': taskId,
                  });
                },
                alignment: Alignment.centerLeft,
                cupertino: (_, __) => CupertinoTextButtonData(minSize: 0),
                child: Text(
                  tr('reply'),
                  style: TextStyleHelper.caption(color: Get.theme.colors().primary),
                ),
              ),
          ],
        ),
      );
    }
    if (comment.show) return const _DeletedComment();
    return const SizedBox();
  }
}

class _HTMLWidgetFactory extends WidgetFactory {
  final _portalInfo = Get.find<PortalInfoController>();

  @override
  Widget? buildImage(BuildMetadata meta, ImageMetadata data) {
    final url = meta.element.attributes['src'];
    if (url != null && url.isNotEmpty && !url.contains('http')) {
      return Image.network(
        _portalInfo.portalUri! + url,
        headers: _portalInfo.headers as Map<String, String>?,
      );
    }

    return super.buildImage(meta, data);
  }
}

class _CommentAuthor extends StatelessWidget {
  final PortalComment comment;
  final CommentItemController controller;

  const _CommentAuthor({
    Key? key,
    required this.comment,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CustomNetworkImage(
              image: comment.userAvatarPath,
              defaultImage: const DefaultAvatar(),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment.userFullName!, style: TextStyleHelper.subtitle1()),
              Text(comment.timeStampStr!,
                  style: TextStyleHelper.caption(
                      color: Get.theme.colors().onBackground.withOpacity(0.6))),
            ],
          ),
        ),
        PlatformPopupMenuButton(
          padding: EdgeInsets.zero,
          onSelected: (value) => _onSelected(value as String, controller),
          icon: Icon(
            PlatformIcons(context).ellipsis,
            color: Get.theme.colors().onSurface.withOpacity(0.5),
          ),
          itemBuilder: (context) {
            return [
              PlatformPopupMenuItem(
                value: 'Copy link',
                child: Text(tr('copyLink')),
              ),
              if (comment.isEditPermissions!)
                PlatformPopupMenuItem(
                  value: 'Edit',
                  child: Text(tr('edit')),
                ),
              if (comment.isEditPermissions!)
                PlatformPopupMenuItem(
                  value: 'Delete',
                  isDestructiveAction: true,
                  textStyle: TextStyleHelper.subtitle1(color: Get.theme.colors().colorError),
                  child: Text(tr('delete')),
                ),
            ];
          },
        ),
      ],
    );
  }
}

class _DeletedComment extends StatelessWidget {
  const _DeletedComment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          tr('commentDeleted'),
          style: TextStyleHelper.body2(
            color: Get.theme.colors().onBackground.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}

Future<void> _onSelected(
  String value,
  CommentItemController controller,
) async {
  switch (value) {
    case 'Copy link':
      await controller.copyLink();
      break;
    case 'Edit':
      controller.toCommentEditingView();
      break;
    case 'Delete':
      await controller.deleteComment();
      break;
    default:
  }
}
