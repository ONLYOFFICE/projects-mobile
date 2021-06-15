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
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/domain/controllers/comments/comment_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:simple_html_css/simple_html_css.dart';

class Comment extends StatelessWidget {
  final PortalComment comment;
  final int taskId;
  const Comment({
    Key key,
    @required this.comment,
    @required this.taskId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(
        CommentItemController(taskId: taskId, comment: comment.obs),
        tag: comment.commentId);

    return Container(
      child: Column(
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
                    child: HTML.toRichText(
                      context,
                      controller.comment.value.commentBody,
                      defaultTextStyle: TextStyleHelper.body2(),
                    ),
                  ),
                  if (comment.isResponsePermissions) const SizedBox(height: 5),
                  if (comment.isResponsePermissions)
                    GestureDetector(
                      onTap: () => Get.toNamed('ReplyCommentView', arguments: {
                        'comment': controller.comment.value,
                        'taskId': taskId,
                      }),
                      child: Text(
                        'Ответить',
                        style: TextStyleHelper.caption(
                            color: Theme.of(context).customColors().primary),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CommentAuthor extends StatelessWidget {
  final PortalComment comment;
  final controller;
  const _CommentAuthor({
    Key key,
    @required this.comment,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          const SizedBox(width: 4),
          SizedBox(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomNetworkImage(
                image: comment.userAvatarPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.userFullName, style: TextStyleHelper.projectTitle),
                Text(comment.timeStampStr,
                    style: TextStyleHelper.caption(
                        color: Theme.of(context)
                            .customColors()
                            .onBackground
                            .withOpacity(0.6))),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: PopupMenuButton(
                onSelected: (value) => _onSelected(value, context, controller),
                icon: Icon(Icons.more_vert_rounded,
                    size: 25,
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.5)),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                        value: 'Copy link', child: Text('Copy link')),
                    if (comment.isEditPermissions)
                      const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                    if (comment.isEditPermissions)
                      const PopupMenuItem(
                          value: 'Delete', child: Text('Delete')),
                  ];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _onSelected(value, context, CommentItemController controller) async {
  switch (value) {
    case 'Copy link':
      await controller.copyLink(context);
      break;
    case 'Edit':
      await Get.toNamed('CommentEditingView', arguments: {
        'commentId': controller.comment.value.commentId,
        'commentBody': controller.comment.value.commentBody,
        'taskId': controller.taskId,
      });
      break;
    case 'Delete':
      await controller.deleteComment(context);
      break;
    default:
  }
}
