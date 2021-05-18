import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/domain/controllers/comments/comment_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:simple_html_css/simple_html_css.dart';

class Comment extends StatelessWidget {
  final PortalComment comment;
  final String portalUri;
  final int taskId;
  final headers;
  const Comment({
    Key key,
    @required this.comment,
    @required this.portalUri,
    @required this.headers,
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
            child: _CommentAuthor(
              comment: comment,
              headers: headers,
              portalUri: portalUri,
              controller: controller,
            ),
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
                        'portalUri': portalUri,
                        'headers': headers,
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
  final String portalUri;
  final controller;
  final headers;
  const _CommentAuthor({
    Key key,
    @required this.comment,
    @required this.portalUri,
    @required this.headers,
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
            child: CircleAvatar(
              //TODO fix avatars path
              backgroundImage: NetworkImage(portalUri + comment.userAvatarPath,
                  headers: headers),
              backgroundColor: Colors.transparent,
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
