import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/comments/new_comment/abstract_new_comment.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/task_detailed/comments/comment_text_field.dart';

class NewCommentView extends StatelessWidget {
  const NewCommentView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewCommentController controller = Get.arguments['controller'];

    return Scaffold(
      appBar: StyledAppBar(
        titleText: tr('newComment'),
        onLeadingPressed: controller.leavePage,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: () => controller.addComment(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: CommentTextField(controller: controller),
      ),
    );
  }
}
