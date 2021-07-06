import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/comments/comment_editing_controller.dart';
import 'package:projects/domain/controllers/comments/item_controller/abstract_comment_item_controller.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/task_detailed/comments/comment_text_field.dart';

class CommentEditingView extends StatelessWidget {
  const CommentEditingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String commentId = Get.arguments['commentId'];
    String commentBody = Get.arguments['commentBody'];
    CommentItemController itemController = Get.arguments['itemController'];

    var controller = Get.put(CommentEditingController(
      commentBody: commentBody,
      commentId: commentId,
      itemController: itemController,
    ));

    return Scaffold(
      appBar: StyledAppBar(
        titleText: tr('taskEditing'),
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
