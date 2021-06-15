import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/domain/controllers/comments/new_comment_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/task_detailed/comments/comment_text_field.dart';

class ReplyCommentView extends StatelessWidget {
  const ReplyCommentView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int taskId = Get.arguments['taskId'];
    PortalComment comment = Get.arguments['comment'];

    var controller = Get.put(
        NewCommentController(parentId: comment.commentId, taskId: taskId));

    return Scaffold(
      appBar: StyledAppBar(
        titleText: 'New comment',
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
                                color: Theme.of(context)
                                    .customColors()
                                    .onSurface)),
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
    );
  }
}
