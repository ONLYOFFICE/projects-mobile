import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/domain/controllers/comments/item_controller/abstract_comment_item_controller.dart';
import 'package:projects/internal/locator.dart';

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

  final TextEditingController _textController = TextEditingController();

  TextEditingController get textController => _textController;

  @override
  void onInit() {
    _textController.text = commentBody;
    super.onInit();
  }

  Future<void> confirm() async {
    if (_textController.text.isEmpty) {
      setTitleError.value = true;
    } else {
      var result = await _api.updateComment(
        commentId: commentId,
        content: _textController.text,
      );
      if (result != null) {
        itemController.comment.value.commentBody = result;
        Get.back();
      } else {
        debugPrint(result);
      }
    }
  }
}
