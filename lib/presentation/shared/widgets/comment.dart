import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/domain/controllers/comments/item_controller/abstract_comment_item_controller.dart';
import 'package:projects/domain/controllers/comments/item_controller/discussion_comment_item_controller.dart';
import 'package:projects/domain/controllers/comments/item_controller/task_comment_item_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/views/task_detailed/comments/reply_comment_view.dart';
import 'package:simple_html_css/simple_html_css.dart';

class Comment extends StatelessWidget {
  final int taskId;
  final int discussionId;
  final PortalComment comment;
  const Comment({
    Key key,
    @required this.comment,
    this.taskId,
    this.discussionId,
  })  : assert(discussionId == null || taskId == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!comment.inactive) {
      CommentItemController controller;

      if (taskId != null) {
        controller = Get.put(
          TaskCommentItemController(taskId: taskId, comment: comment.obs),
          tag: '${comment.commentId} ${comment.commentBody}',
          permanent: false,
        );
      } else {
        controller = Get.put(
          DiscussionCommentItemController(
            discussionId: discussionId,
            comment: comment.obs,
          ),
          tag: '${comment.commentId} ${comment.commentBody}',
          permanent: false,
        );
      }

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
                        defaultTextStyle: TextStyleHelper.body2(
                          color: Get.theme.colors().onSurface,
                        ),
                      ),
                    ),
                    if (comment.isResponsePermissions)
                      const SizedBox(height: 5),
                    if (comment.isResponsePermissions)
                      GestureDetector(
                        onTap: () {
                          return Get.find<NavigationController>()
                              .to(const ReplyCommentView(), arguments: {
                            'comment': controller.comment.value,
                            'discussionId': discussionId,
                            'taskId': taskId,
                          });
                        },
                        child: Text(
                          'Ответить',
                          style: TextStyleHelper.caption(
                              color: Get.theme.colors().primary),
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
    return const _DeletedComment();
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
                        color:
                            Get.theme.colors().onBackground.withOpacity(0.6))),
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
                  onSelected: (value) =>
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
                      if (comment.isEditPermissions)
                        PopupMenuItem(
                          value: 'Edit',
                          child: Text(tr('edit')),
                        ),
                      if (comment.isEditPermissions)
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
      ),
    );
  }
}

class _DeletedComment extends StatelessWidget {
  const _DeletedComment({Key key}) : super(key: key);

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

void _onSelected(value, context, CommentItemController controller) async {
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
