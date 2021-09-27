import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';

abstract class NewCommentController extends GetxController {
  final int idFrom;
  final String parentId;

  NewCommentController({
    this.parentId,
    this.idFrom,
  });

  RxBool setTitleError = false.obs;
  HtmlEditorController get textController;

  void addComment(context);
  void addReplyComment(context);
  void leavePage();

  void emptyTitleError() async {
    setTitleError.value = true;
    await 900.milliseconds.delay().then((_) => setTitleError.value = false);
  }
}
