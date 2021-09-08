import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

class NewProjectDescription extends StatelessWidget {
  const NewProjectDescription({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller =
        Get.arguments['controller']; //Get.find<NewProjectController>();
    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor:
          platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        titleText: tr('description'),
        leading: IconButton(
            icon: Get.put(PlatformController()).isMobile
                ? const Icon(Icons.arrow_back_rounded)
                : const Icon(Icons.close),
            onPressed: () => controller.leaveDescriptionView(
                controller.descriptionController.value.text)),
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
          autofocus: true,
          controller: controller.descriptionController,
          maxLines: null,
          style: TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface),
          decoration: InputDecoration.collapsed(
              hintText: tr('enterText'),
              hintStyle: TextStyleHelper.subtitle1()),
        ),
      ),
    );
  }
}
