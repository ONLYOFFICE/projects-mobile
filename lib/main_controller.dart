import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/internal/splash_view.dart';
import 'package:projects/main_view.dart';
import 'package:projects/presentation/views/authentication/portal_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';

class MainController extends GetxController {
  final _secureStorage = locator<SecureStorage>();
  // ignore: unnecessary_cast
  Rx<Widget> mainPage = (const SplashView() as Widget).obs;

  // ignore: unnecessary_cast
  final navigationView = NavigationView() as Widget;
  // ignore: unnecessary_cast
  final portalInputView = PortalInputView() as Widget;

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
    }));
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> isAuthorized() async {
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

    var isAuthValid = await locator<AuthService>().checkAuthorization();
    if (!isAuthValid) await logout();

    return isAuthValid;
  }

  Future<void> logout() async {
    var storage = locator<Storage>();

    await _secureStorage.delete('expires');
    await _secureStorage.delete('portalName');
    await _secureStorage.delete('token');

    await storage.remove('taskFilters');
    await storage.remove('projectFilters');
    await storage.remove('discussionFilters');

    Get.find<PortalInfoController>().logout();
  }

  void setupMainPage() {
    if (noInternet.isTrue) return;

    isAuthorized().then((isAuthorized) {
      return {
        if (isAuthorized)
          {
            if (!(mainPage.value is NavigationView))
              {
                // ignore: unnecessary_cast
                mainPage.value = navigationView,
              }
          }
        else if (!(mainPage.value is PortalInputView))
          {
            // ignore: unnecessary_cast
            mainPage.value = portalInputView,
          }
      };
    });
  }
}
