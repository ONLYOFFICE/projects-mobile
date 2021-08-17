import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsService {
  final _passcodeService = locator<PasscodeService>();

  Future<bool> get isPasscodeEnable async =>
      await _passcodeService.isPasscodeEnable;

  Future<void> openEmailApp(String url, context) async {
    try {
      await launch(url);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return StyledAlertDialog(
            titleText: tr('failedToSendFeedback'),
            cancelText: tr('close'),
            acceptText: tr('goToForum'),
            acceptColor: Theme.of(context).colors().primary,
            onAcceptTap: () async =>
                launch('https://cloud.onlyoffice.org/viewforum.php?f=48'),
          );
        },
      );
    }
  }
}
