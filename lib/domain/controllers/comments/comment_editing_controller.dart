import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/domain/controllers/comments/item_controller/abstract_comment_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class CommentEditingController extends GetxController {
  final _api = locator<CommentsService>();
  final String commentBody;
  final String commentId;
  final CommentItemController itemController;

  CommentEditingController({
    this.commentBody,
    this.commentId,
    this.itemController,
  });

  RxBool setTitleError = false.obs;

  final HtmlEditorController _textController = HtmlEditorController();

  HtmlEditorController get textController => _textController;

  Future<void> confirm() async {
    var text = await _textController.getText();

    if (text.isEmpty) {
      setTitleError.value = true;
      return;
    }
    if (text == commentBody) {
      Get.back();
      return;
    }

    var result = await _api.updateComment(
      commentId: commentId,
      content: text,
    );
    if (result != null) {
      itemController.comment.value.commentBody = result;
      Get.back();
    } else {
      debugPrint(result);
    }
  }

  void leavePage() async {
    var text = await _textController.getText();
    if (text != commentBody) {
      await Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        onAcceptTap: () {
          _textController.clear();
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    } else {
      Get.back();
    }
  }
}
