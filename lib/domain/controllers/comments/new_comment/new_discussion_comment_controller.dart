import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/domain/controllers/comments/new_comment/abstract_new_comment.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled_snackbar.dart';

class NewDiscussionCommentController extends GetxController
    implements NewCommentController {
  final _api = locator<CommentsService>();

  @override
  final int idFrom;
  final String parentId;

  NewDiscussionCommentController({
    this.parentId,
    this.idFrom,
  });

  @override
  RxBool setTitleError = false.obs;

  final TextEditingController _textController = TextEditingController();

  @override
  TextEditingController get textController => _textController;

  @override
  Future addComment(context) async {
    if (_textController.text.isEmpty)
      setTitleError.value = true;
    else {
      setTitleError.value = false;
      PortalComment newComment = await _api.addMessageComment(
          content: _textController.text, messageId: idFrom);
      if (newComment != null) {
        var discussionController = Get.find<DiscussionItemController>();
        // ignore: unawaited_futures
        discussionController.onRefresh();
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
            context: context,
            text: 'Comment had been created',
            buttonText: ''));
      }
    }
  }

  @override
  Future addReplyComment(context) async {
    if (_textController.text.isEmpty)
      setTitleError.value = true;
    else {
      setTitleError.value = false;
      PortalComment newComment = await _api.addMessageReplyComment(
        content: _textController.text,
        messageId: idFrom,
        parentId: parentId,
      );
      if (newComment != null) {
        var discussionController = Get.find<DiscussionItemController>();
        // ignore: unawaited_futures
        discussionController.onRefresh();
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
            context: context,
            text: 'Comment had been created',
            buttonText: ''));
      }
    }
  }
}
