import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

class NewProjectDescription extends StatelessWidget {
  const NewProjectDescription({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller =
        Get.arguments['controller']; //Get.find<NewProjectController>();
    return Scaffold(
      appBar: StyledAppBar(
        titleText: tr('description'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
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
          style: TextStyleHelper.subtitle1(
              color: Theme.of(context).customColors().onSurface),
          decoration: InputDecoration.collapsed(
              hintText: tr('enterText'),
              hintStyle: TextStyleHelper.subtitle1()),
        ),
      ),
    );
  }
}
