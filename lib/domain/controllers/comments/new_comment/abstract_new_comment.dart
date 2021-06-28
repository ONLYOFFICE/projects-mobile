import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class NewCommentController {
  final int idFrom;
  NewCommentController(this.idFrom);

  RxBool setTitleError;
  TextEditingController get textController;

  void addComment(context);
  void addReplyComment(context);
  void leavePage();
}
