// ignore_for_file: unawaited_futures

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
import 'package:get_it/get_it.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/portal_info_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/internal/splash_view.dart';
import 'package:projects/main_view.dart';
import 'package:projects/presentation/views/authentication/portal_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';
import 'package:projects/presentation/views/no_internet_view.dart';

class MainController extends GetxController {
  final SecureStorage _secureStorage = locator<SecureStorage>();
  // ignore: unnecessary_cast
  Rx<Widget> mainPage = (const SplashView() as Widget).obs;

  // ignore: unnecessary_cast
  final navigationView = NavigationView() as Widget;
  // ignore: unnecessary_cast
  final portalInputView = PortalInputView() as Widget;

  var noInternet = false;
  var isSessionStarted = false;
  bool correctPasscodeChecked = false;

  var subscriptions = <StreamSubscription>[];

  MainController() {
    Connectivity().checkConnectivity().then((result) => {
          noInternet = result == ConnectivityResult.none,
          if (result == ConnectivityResult.none) Get.to(const NoInternetScreen())
        });

    _setupSubscriptions();
  }

  void _setupSubscriptions() {
    if (subscriptions.isNotEmpty) {
      for (final item in subscriptions) {
        item.cancel();
      }
    }

    subscriptions.add(Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (noInternet == (result == ConnectivityResult.none)) return;
      if (result == ConnectivityResult.none) {
        Get.to(const NoInternetScreen());

        locator.get<CoreApi>().cancellationToken.cancel();
      } else {
        GetIt.instance.resetLazySingleton<CoreApi>();
        if (isSessionStarted)
          Get.back();
        else
          Get.offAll(() => const MainView());
      }
      noInternet = result == ConnectivityResult.none;

      setupMainPage();
    }));

    subscriptions.add(locator<EventHub>().on('loginSuccess', (dynamic data) async {
      mainPage.value = navigationView;
      Get.offAll(() => const MainView());
      Get.find<UserController>().getUserInfo();
      Get.find<UserController>().getSecurityInfo();

      Get.find<PortalInfoController>().setup();
    }));

    subscriptions.add(locator<EventHub>().on('logoutSuccess', (dynamic data) async {
      mainPage.value = portalInputView;

      GetIt.instance.resetLazySingleton<CoreApi>();
      await Get.offAll(() => const MainView());
    }));
  }

  Future<void> setupMainPage() async {
    final connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) return;

    isSessionStarted = true;

    isAuthorized().then((isAuthorized) {
      return {
        if (isAuthorized)
          {
            if (mainPage.value is! NavigationView)
              {
                mainPage.value = navigationView,
              }
          }
        else if (mainPage.value is! PortalInputView)
          {
            mainPage.value = portalInputView,
          }
      };
    });
  }

  Future<bool> isAuthorized() async {
    final expirationDate = await _secureStorage.getString('expires');
    final token = await _secureStorage.getString('token');
    final portalName = await _secureStorage.getString('portalName');

    if (expirationDate == null ||
        expirationDate.isEmpty ||
        token == null ||
        token.isEmpty ||
        portalName == null ||
        portalName.isEmpty) return false;

    final expiration = DateTime.parse(expirationDate);
    if (expiration.isBefore(DateTime.now())) return false;

    final isAuthValid = await locator<AuthService>().checkAuthorization();
    if (!isAuthValid) await logout();

    return isAuthValid;
  }

  Future<void> logout() async {
    final storage = locator<Storage>();

    await _secureStorage.delete('expires');
    await _secureStorage.delete('portalName');
    await _secureStorage.delete('token');

    await storage.remove('taskFilters');
    await storage.remove('projectFilters');
    await storage.remove('discussionFilters');

    Get.find<PortalInfoController>().logout();
  }
}
