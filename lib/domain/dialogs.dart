/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'dart:async';
import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/account_controller.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class ErrorDialog extends GetxController {
  final queue = Queue<String>();

  bool dialogIsShown = false;

  Future<void> show(String message, {bool awaited = false}) async {
    if (message.isNotEmpty) addToQueue(message);

    if (awaited)
      await processQueue();
    else
      unawaited(processQueue());
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

    final error = queue.first;

    await Get.find<NavigationController>().showPlatformDialog(
      WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: SingleButtonDialog(
          titleText: tr('error'),
          contentText: _customErrors[error.toLowerCase()] ?? error,
          acceptText: tr('ok'),
          onAcceptTap: () async => {
            Get.back(),
            dialogIsShown = false,
            if (_blockingErrors[error.toLowerCase()] != null)
              {
                await Get.put(AccountManager()).clearToken(),
                Get.find<LoginController>().logout(),
                dialogIsShown = false,
                queue.clear(),
              }
            else
              {
                queue.removeFirst(),
                processQueue(),
              }
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  void addToQueue(String message) {
    queue.add(message);

    final list = queue.toSet().toList();

    queue.clear();
    queue.addAll(list);
  }
}

Map _blockingErrors = {
  'unauthorized': 'unauthorized',
  'forbidden': 'Forbidden',
  'payment required': 'Payment required',
  'paymentrequired': 'Payment required',
  'the paid period is over': 'The paid period is over',
  'access to the projects module is forbidden': 'Access to the Projects module is Forbidden',
  'contact the portal administrator for access to the projects module.':
      'Contact the portal administrator for access to the Projects module.',
};

Map<String, String> _customErrors = {
  'user authentication failed': tr('authenticationFailed'),
  'no address associated with hostname': tr('noAdress'),
  'unauthorized': tr('unauthorized'),
  'forbidden': tr('forbidden'),
};
