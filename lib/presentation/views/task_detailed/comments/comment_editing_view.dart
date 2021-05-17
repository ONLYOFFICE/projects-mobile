import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/comments/comment_editing_controller.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/task_detailed/comments/comment_text_field.dart';

class CommentEditingView extends StatelessWidget {
  const CommentEditingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String commentId = Get.arguments['commentId'];
    String commentBody = Get.arguments['commentBody'];

    var controller = Get.put(CommentEditingController(
      commentBody: commentBody,
      commentId: commentId,
    ));

    controller.init();

    return Scaffold(
      appBar: StyledAppBar(
        titleText: 'Task editing',
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: () async => controller.confirm(),
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
