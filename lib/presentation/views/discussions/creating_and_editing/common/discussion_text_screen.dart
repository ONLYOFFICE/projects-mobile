import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/html_text_editor.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

class NewDiscussionTextScreen extends StatelessWidget {
  const NewDiscussionTextScreen({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final DiscussionActionsController controller;

  @override
  Widget build(BuildContext context) {
    final platformController = Get.find<PlatformController>();

    return WillPopScope(
      onWillPop: () async {
        controller.leaveTextView();
        return false;
      },
      child: Scaffold(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        appBar: StyledAppBar(
          backgroundColor:
              platformController.isMobile ? null : Get.theme.colors().surface,
          titleText: tr('text'),
          backButtonIcon: Get.put(PlatformController()).isMobile
              ? const Icon(Icons.arrow_back_rounded)
              : const Icon(Icons.close),
          onLeadingPressed: controller.leaveTextView,
          actions: [
            IconButton(
                icon: const Icon(Icons.check_rounded),
                onPressed: controller.confirmText)
          ],
        ),
        body: HtmlTextEditor(
          initialText: controller.text.value,
          textController: controller.textController,
          hintText: tr('discussionText'),
        ),
      ),
    );
  }
}
