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

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/internal/splash_view.dart';
import 'package:projects/main_view.dart';
import 'package:projects/presentation/views/authentication/portal_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';

class MainController extends GetxController {
  // ignore: unnecessary_cast
  Rx<Widget> mainPage = (const SplashView() as Widget).obs;

  var noInternet = false.obs;
  bool correctPasscodeChecked = false;

  var subscriptions = <StreamSubscription>[];

  MainController() {
    Connectivity()
        .checkConnectivity()
        .then((value) => {noInternet.value = value == ConnectivityResult.none});

    subscriptions.add(Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      noInternet.value = result == ConnectivityResult.none;
      setupMainPage();
    }));

    subscriptions
        .add(locator<EventHub>().on('loginSuccess', (dynamic data) async {
      setupMainPage();
      await Get.offAll(() => MainView());
    }));

    subscriptions
        .add(locator<EventHub>().on('logoutSuccess', (dynamic data) async {
      setupMainPage();
      await Get.offAll(() => MainView());

      Get.find<NavigationController>().clearCurrentIndex();
    }));
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> isAuthorized() async {
    var _secureStorage = locator<SecureStorage>();
    var expirationDate = await _secureStorage.getString('expires');
    var token = await _secureStorage.getString('token');
    var portalName = await _secureStorage.getString('portalName');

    if (expirationDate == null ||
        expirationDate.isEmpty ||
        token == null ||
        token.isEmpty ||
        portalName == null ||
        portalName.isEmpty) return false;

    var expiration = DateTime.parse(expirationDate);
    if (expiration.isBefore(DateTime.now())) return false;

    return true;
  }

  void setupMainPage() {
    if (noInternet.isTrue) return;

    isAuthorized().then((isAuthorized) => {
          if (isAuthorized)
            {
              if (!(mainPage.value is NavigationView))
                {
                  // ignore: unnecessary_cast
                  mainPage.value = NavigationView() as Widget,
                }
            }
          else if (!(mainPage.value is PortalInputView))
            {
              // ignore: unnecessary_cast
              mainPage.value = PortalInputView() as Widget,
            }
        });
  }
}
