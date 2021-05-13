import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/comments/new_comment_controller.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

class NewCommentView extends StatelessWidget {
  final int taskId;
  final int parentId;

  const NewCommentView({
    Key key,
    this.parentId,
    this.taskId,
  }) : super(key: key);

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
        child: TextField(
          maxLines: null,
          autofocus: true,
          controller: controller.textController,
          scrollPadding: const EdgeInsets.all(10),
          decoration: const InputDecoration.collapsed(
            hintText: 'Reply text',
          ),
        ),
      ),
    );
  }
}
