import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';

abstract class CommentItemController {
  final Rx<PortalComment> comment = null;

  Future<void> copyLink(context);
  Future<void> deleteComment(context);

  void toCommentEditingView();
}
