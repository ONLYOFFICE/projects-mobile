import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/domain/controllers/comments/new_comment/abstract_new_comment.dart';
import 'package:projects/domain/controllers/comments/new_comment/new_discussion_comment_controller.dart';
import 'package:projects/domain/controllers/comments/new_comment/new_task_comment_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/task_detailed/comments/comment_text_field.dart';

class ReplyCommentView extends StatelessWidget {
  const ReplyCommentView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PortalComment comment = Get.arguments['comment'];
    NewCommentController controller;
    final platformController = Get.find<PlatformController>();

    if (Get.arguments['taskId'] != null) {
      controller = Get.put(
        NewTaskCommentController(
          idFrom: Get.arguments['taskId'],
          parentId: comment.commentId,
        ),
      );
    }
    if (Get.arguments['discussionId'] != null) {
      controller = Get.put(
        NewDiscussionCommentController(
          idFrom: Get.arguments['discussionId'],
          parentId: comment.commentId,
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        controller.leavePage();
        return false;
      },
      child: Scaffold(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        appBar: StyledAppBar(
          backgroundColor:
              platformController.isMobile ? null : Get.theme.colors().surface,
          titleText: tr('newComment'),
          onLeadingPressed: controller.leavePage,
          actions: [
            IconButton(
              icon: const Icon(Icons.done_rounded),
              onPressed: () => controller.addReplyComment(context),
            )
          ],
        ),
        body: SingleChildScrollView(
          // controller: controller,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 16),
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
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (comment.userFullName != null)
                          Text(comment.userFullName,
                              style: TextStyleHelper.subtitle1(
                                  color: Get.theme.colors().onSurface)),
                        Text(
                          comment.commentBody,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.caption(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(16),
                child: CommentTextField(controller: controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
