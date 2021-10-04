import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/comments/new_comment/abstract_new_comment.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/html_text_editor.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

class NewCommentView extends StatelessWidget {
  const NewCommentView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewCommentController controller = Get.arguments['controller'];
    final platformController = Get.find<PlatformController>();

    return WillPopScope(
      onWillPop: () async {
        controller.leavePage();
        return false;
      },
      child: Scaffold(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        appBar: StyledAppBar(
          backgroundColor:
              platformController.isMobile ? null : Get.theme.colors().surface,
          titleText: tr('newComment'),
          backButtonIcon: Get.put(PlatformController()).isMobile
              ? const Icon(Icons.arrow_back_rounded)
              : const Icon(Icons.close),
          onLeadingPressed: controller.leavePage,
          actions: [
            IconButton(
              icon: const Icon(Icons.done_rounded),
              onPressed: () => controller.addComment(context),
            ),
          ],
        ),
        body: Obx(
          () => HtmlTextEditor(
            hintText: tr('replyText'),
            hasError: controller.setTitleError.value,
            textController: controller.textController,
          ),
        ),
      ),
    );
  }
}
