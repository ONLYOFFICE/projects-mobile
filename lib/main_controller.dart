import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/controllers/passcode/passcode_checking_controller.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/internal/splash_view.dart';
import 'package:projects/presentation/views/authentication/portal_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';

class MainController extends GetxController {
  // ignore: unnecessary_cast
  Rx<Widget> mainPage = (const SplashView() as Widget).obs;

  var noInternet = false.obs;
  bool correctPasscodeChecked = false;

  var subscriptions = <StreamSubscription>[];

  final passcodeCheckingController = Get.find<PasscodeCheckingController>();
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

    subscriptions.add(locator<EventHub>().on('loginSuccess', (dynamic data) {
      setupMainPage();
    }));

    subscriptions.add(locator<EventHub>().on('logoutSuccess', (dynamic data) {
      setupMainPage();
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
            // ignore: unnecessary_cast
            mainPage.value = PortalInputView() as Widget,
          // })
        });
  }
}
