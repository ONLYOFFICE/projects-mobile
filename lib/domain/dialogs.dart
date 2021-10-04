import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class ErrorDialog extends GetxController {
  final queue = Queue<String>();

  bool dialogIsShown = false;

  Future<void> show(String message) async {
    addToQueue(message);

    // ignore: unawaited_futures
    processQueue();
  }

  void hide() {
    Get.back();
  }

  Future<void> processQueue() async {
    if (queue.isEmpty) return;

    if (dialogIsShown) {
      return;
    }

    dialogIsShown = true;

    var error = queue.first;

    await Get.dialog(SingleButtonDialog(
        titleText: tr('error'),
        contentText: _customErrors[error] ?? error,
        acceptText: tr('ok'),
        onAcceptTap: () => {
              Get.back(),
              dialogIsShown = false,
              if (_blockingErrors[error] != null)
                {
                  Get.find<LoginController>().logout(),
                  dialogIsShown = false,
                  queue.clear(),
                }
              else
                {
                  queue.removeFirst(),
                  processQueue(),
                }
            }));
  }

  void addToQueue(String message) {
    queue.add(message);

    var list = queue.toSet().toList();

    queue.clear();
    queue.addAll(list);
  }
}

Map _blockingErrors = {
  'Forbidden': 'Forbidden',
  'Payment required': 'Payment required',
  'The paid period is over': 'The paid period is over',
  'Access to the Projects module is Forbidden':
      'Access to the Projects module is Forbidden',
  'Contact the portal administrator for access to the Projects module.':
      'Contact the portal administrator for access to the Projects module.',
};

Map _customErrors = {
  'User authentication failed': tr('authenticationFailed'),
  'No address associated with hostname': tr('noAdress'),
};
