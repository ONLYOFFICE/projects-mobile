import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class ErrorDialog extends GetxController {
  final queue = Queue<String>();

  bool dialogIsShown = false;

  Future<void> show(String message) async {
    addToQueue(message);

    await processQueue();
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
        contentText: error,
        acceptText: tr('ok'),
        onAcceptTap: () => {
              Get.back(),
              dialogIsShown = false,
              queue.removeFirst(),
              processQueue(),
            }));
  }

  void addToQueue(String message) {
    queue.add(message);

    var list = queue.toSet().toList();

    queue.clear();
    queue.addAll(list);
  }
}
