import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/internal/locator.dart';

class CommentsController extends GetxController {
  final _api = locator<CommentsService>();

  var comments = [].obs;
  RxBool loaded = false.obs;

  Future getTaskComments({@required int taskId}) async {
    loaded.value = false;
    comments.value = await _api.getTaskComments(taskId: taskId);
    loaded.value = true;
  }
}
