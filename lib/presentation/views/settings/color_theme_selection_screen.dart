import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/settings/settings_controller.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';

class ColorThemeSelectionScreen extends StatelessWidget {
  const ColorThemeSelectionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<SettingsController>();
    final platformController = Get.find<PlatformController>();

    return Obx(
      () => Scaffold(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        appBar: StyledAppBar(
          backgroundColor:
              platformController.isMobile ? null : Get.theme.colors().surface,
          titleText: tr('colorTheme'),
          backButtonIcon: const Icon(Icons.arrow_back_rounded),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _ColorThemeTile(
              text: tr('sameAsSystem'),
              isSelected: controller.currentTheme.value == 'sameAsSystem',
              onTap: () async => await controller.setTheme('sameAsSystem'),
            ),
            const StyledDivider(leftPadding: 16, rightPadding: 16),
            _ColorThemeTile(
              text: tr('lightTheme'),
              isSelected: controller.currentTheme.value == 'lightTheme',
              onTap: () async => await controller.setTheme('lightTheme'),
            ),
            const StyledDivider(leftPadding: 16, rightPadding: 16),
            _ColorThemeTile(
              text: tr('darkTheme'),
              onTap: () async => await controller.setTheme('darkTheme'),
              isSelected: controller.currentTheme.value == 'darkTheme',
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorThemeTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function onTap;
  const _ColorThemeTile({
    Key key,
    @required this.text,
    this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 28, 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyleHelper.projectTitle),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                color: Get.theme.colors().onBackground.withOpacity(0.6),
              )
          ],
        ),
      ),
    );
  }
}
