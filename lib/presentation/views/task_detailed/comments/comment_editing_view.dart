import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/comments/comment_editing_controller.dart';
import 'package:projects/domain/controllers/comments/item_controller/abstract_comment_item_controller.dart';
import 'package:projects/presentation/shared/widgets/html_text_editor.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

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

    return WillPopScope(
      onWillPop: () async {
        controller.leavePage();
        return false;
      },
      child: Scaffold(
        appBar: StyledAppBar(
          titleText: tr('commentEditing'),
          onLeadingPressed: controller.leavePage,
          actions: [
            IconButton(
              icon: const Icon(Icons.done_rounded),
              onPressed: () async => controller.confirm(),
            ),
          ],
        ),
        body: Obx(
          () => HtmlTextEditor(
            hintText: tr('replyText'),
            hasError: controller.setTitleError.value,
            initialText: commentBody,
            textController: controller.textController,
          ),
        ),
      ),
    );
  }
}
