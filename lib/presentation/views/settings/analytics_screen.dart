import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/settings/settings_controller.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: StyledAppBar(titleText: tr('analytics')),
      body: Obx(
        () => SwitchListTile(
          value: controller.shareAnalytics.value,
          contentPadding: const EdgeInsets.fromLTRB(16, 14, 5, 30),
          title: Text(tr('shareAnalytics'),
              style: TextStyleHelper.subtitle1(
                  color: Get.theme.colors().onBackground)),
          subtitle: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(tr('shareAnalyticsDescription'),
                  style: TextStyleHelper.body2(
                      color: Theme.of(context)
                          .colors()
                          .onSurface
                          .withOpacity(0.6)))),
          onChanged: controller.changeAnalyticsSharingEnability,
        ),
      ),
    );
  }
}
