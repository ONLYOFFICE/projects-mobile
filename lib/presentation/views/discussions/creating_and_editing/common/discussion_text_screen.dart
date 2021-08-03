import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

class NewDiscussionTextScreen extends StatelessWidget {
  const NewDiscussionTextScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DiscussionActionsController controller = Get.arguments['controller'];
    return Scaffold(
      appBar: StyledAppBar(
        titleText: tr('text'),
        backButtonIcon: Get.put(PlatformController()).isMobile
            ? const Icon(Icons.arrow_back_rounded)
            : const Icon(Icons.close),
        onLeadingPressed: () => controller.leaveTextView(),
        actions: [
          IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: controller.confirmText)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 12, 16),
        child: TextField(
          controller: controller.textController.value,
          autofocus: true,
          maxLines: null,
          style: TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface),
          decoration: InputDecoration.collapsed(
              hintText: tr('discussionText'),
              hintStyle: TextStyleHelper.subtitle1()),
        ),
      ),
    );
  }
}
