import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/domain/controllers/comments/comment_item_controller.dart';
import 'package:projects/internal/locator.dart';

class CommentEditingController extends GetxController {
  final _api = locator<CommentsService>();
  final String commentBody;
  final String commentId;

  CommentEditingController({this.commentBody, this.commentId});

  RxBool setTitleError = false.obs;

  final TextEditingController _textController = TextEditingController();

  TextEditingController get textController => _textController;

  void init() => _textController.text = commentBody;

  Future<void> confirm() async {
    if (_textController.text.isEmpty) {
      setTitleError.value = true;
    } else {
      var result = await _api.updateComment(
        commentId: commentId,
        content: _textController.text,
      );
      if (result != null) {
        var controller = Get.find<CommentItemController>(tag: commentId);
        controller.comment.value.commentBody = result;
        Get.back();
      } else {
        print('error');
        print(result);
      }
    }
  }
}
