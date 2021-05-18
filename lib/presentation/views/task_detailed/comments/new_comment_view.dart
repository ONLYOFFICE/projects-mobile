import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/comments/new_comment_controller.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/task_detailed/comments/comment_text_field.dart';

class NewCommentView extends StatelessWidget {
  const NewCommentView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int taskId = Get.arguments['taskId'];
    var controller = Get.put(NewCommentController(taskId: taskId));

    return Scaffold(
      appBar: StyledAppBar(
        titleText: 'New comment',
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: () => controller.addTaskComment(context),
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
