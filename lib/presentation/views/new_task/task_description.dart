import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

class TaskDescription extends StatelessWidget {
  const TaskDescription({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.arguments['controller'];

    final platformController = Get.find<PlatformController>();

    return WillPopScope(
      onWillPop: () async {
        controller
            .leaveDescriptionView(controller.descriptionController.value.text);
        return false;
      },
      child: Scaffold(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        appBar: StyledAppBar(
          backgroundColor:
              platformController.isMobile ? null : Get.theme.colors().surface,
          titleText: tr('description'),
          backButtonIcon: Get.put(PlatformController()).isMobile
              ? const Icon(Icons.arrow_back_rounded)
              : const Icon(Icons.close),
          onLeadingPressed: () => controller.leaveDescriptionView(
              controller.descriptionController.value.text),
          actions: [
            IconButton(
                icon: const Icon(Icons.check_rounded),
                onPressed: () => controller.confirmDescription(
                    controller.descriptionController.value.text))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 12, 16),
          child: TextField(
            controller: controller.descriptionController.value,
            autofocus: true,
            maxLines: null,
            style:
                TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface),
            decoration: InputDecoration.collapsed(
                hintText: tr('taskDescription'),
                hintStyle: TextStyleHelper.subtitle1()),
          ),
        ),
      ),
    );
  }
}
