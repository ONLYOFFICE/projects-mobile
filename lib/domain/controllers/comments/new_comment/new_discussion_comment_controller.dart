import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/domain/controllers/comments/new_comment/abstract_new_comment.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class NewDiscussionCommentController extends NewCommentController {
  final _api = locator<CommentsService>();

  @override
  // ignore: overridden_fields
  final int idFrom;
  @override
  // ignore: overridden_fields
  final String parentId;

  NewDiscussionCommentController({
    this.parentId,
    this.idFrom,
  });

  final HtmlEditorController _textController = HtmlEditorController();

  @override
  HtmlEditorController get textController => _textController;

  @override
  Future addComment(context) async {
    var text = await _textController.getText();
    if (text.isEmpty) {
      emptyTitleError();
    } else {
      setTitleError.value = false;
      PortalComment newComment =
          await _api.addMessageComment(content: text, messageId: idFrom);
      if (newComment != null) {
        _textController.clear();
        var discussionController = Get.find<DiscussionItemController>();
        await discussionController.onRefresh(showLoading: false);
        discussionController.scrollToLastComment();
        Get.back();
        MessagesHandler.showSnackBar(
            context: context, text: tr('commentCreated'));
      }
    }
  }

  @override
  Future addReplyComment(context) async {
    var text = await _textController.getText();
    if (text.isEmpty) {
      emptyTitleError();
    } else {
      setTitleError.value = false;
      PortalComment newComment = await _api.addMessageReplyComment(
        content: text,
        messageId: idFrom,
        parentId: parentId,
      );
      if (newComment != null) {
        _textController.clear();
        var discussionController = Get.find<DiscussionItemController>();
        // ignore: unawaited_futures
        discussionController.onRefresh();
        Get.back();
        MessagesHandler.showSnackBar(
            context: context, text: tr('commentCreated'));
      }
    }
  }

  @override
  void leavePage() async {
    var text = await _textController.getText();
    if (text.isNotEmpty) {
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
