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
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/default_avatar.dart';
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

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: _CommentAuthor(comment: comment, controller: controller),
          ),
          const SizedBox(height: 28),
          Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: HtmlWidget(
                      controller.comment!.value.commentBody!,
                    ),
                  ),
                  if (comment.isResponsePermissions!) const SizedBox(height: 5),
                  if (comment.isResponsePermissions!)
                    GestureDetector(
                      onTap: () async {
                        return await Get.find<NavigationController>()
                            .toScreen(const ReplyCommentView(), arguments: {
                          'comment': controller.comment!.value,
                          'discussionId': discussionId,
                          'taskId': taskId,
                        });
                      },
                      child: Text(
                        tr('reply'),
                        style: TextStyleHelper.caption(
                            color: Get.theme.colors().primary),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      );
    }
    if (comment.show) return const _DeletedComment();
    return const SizedBox();
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
              Text(comment.userFullName!, style: TextStyleHelper.projectTitle),
              Text(comment.timeStampStr!,
                  style: TextStyleHelper.caption(
                      color: Get.theme.colors().onBackground.withOpacity(0.6))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 7),
          child: SizedBox(
            width: 60,
            child: Padding(
              padding: const EdgeInsets.only(left: 35),
              child: PopupMenuButton(
                onSelected: (String value) =>
                    _onSelected(value, context, controller),
                icon: Icon(Icons.more_vert_rounded,
                    size: 25,
                    color: Get.theme.colors().onSurface.withOpacity(0.5)),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'Copy link',
                      child: Text(tr('copyLink')),
                    ),
                    if (comment.isEditPermissions!)
                      PopupMenuItem(
                        value: 'Edit',
                        child: Text(tr('edit')),
                      ),
                    if (comment.isEditPermissions!)
                      PopupMenuItem(
                        value: 'Delete',
                        child: Text(
                          tr('delete'),
                          style: TextStyleHelper.subtitle1(
                              color: Get.theme.colors().colorError),
                        ),
                      ),
                  ];
                },
              ),
            ),
          ),
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
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(tr('commentDeleted'), style: TextStyleHelper.body2()),
      ),
    );
  }
}

Future<void> _onSelected(
  String value,
  BuildContext context,
  CommentItemController controller,
) async {
  switch (value) {
    case 'Copy link':
      await controller.copyLink(context);
      break;
    case 'Edit':
      controller.toCommentEditingView();
      break;
    case 'Delete':
      await controller.deleteComment(context);
      break;
    default:
  }
}
