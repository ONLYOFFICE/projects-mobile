import 'dart:async';

import 'package:event_hub/event_hub.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/fullscreen_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';

class NavigationController extends GetxController {
  var tabIndex = 0;
  var onMoreView = false;
  final _userController = Get.find<UserController>();
  Rx<PortalUserItemController> selfUserItem = PortalUserItemController().obs;

  @override
  void onInit() {
    var portalController = Get.find<PortalInfoController>();
    if (portalController.portalName == null) portalController.onInit();
    _userController.getUserInfo().whenComplete(() => selfUserItem.value =
        PortalUserItemController(portalUser: _userController.user));

    super.onInit();
  }

  @override
  void onClose() {
    clearCurrentIndex();
    super.onClose();
  }

  void showMoreView() {
    onMoreView = true;
    locator<EventHub>().fire('moreViewVisibilityChanged', onMoreView);
  }

  void hideMoreView() {
    onMoreView = false;
    locator<EventHub>().fire('moreViewVisibilityChanged', onMoreView);
  }

  void changeTabIndex(int index) {
    if (index < 3) {
      hideMoreView();
      tabIndex = index;
      update();
    } else {
      if (index == 3) {
        if (!onMoreView) {
          showMoreView();
          update();
        } else {
          hideMoreView();
          update();
        }
      } else {
        hideMoreView();
        tabIndex = index;
        update();
      }
    }
  }

  void changeTabletIndex(int index) {
    hideMoreView();
    tabIndex = index;
    update();
  }

  void clearCurrentIndex() => tabIndex = null;

  Future toScreen(
    Widget widget, {
    bool preventDuplicates,
    Map<String, dynamic> arguments,
  }) async {
    if (Get.find<PlatformController>().isMobile) {
      return await Get.to(
        () => widget,
        preventDuplicates: preventDuplicates ?? false,
        arguments: arguments,
      );
    } else {
      //TODO modal dialog also overlap dimmed background, fix if possible
      return await Get.dialog(
        ModalScreenView(contentView: widget),
        barrierDismissible: false,
        arguments: arguments,
      );
    }
  }

  void to(Widget widget,
      {bool preventDuplicates, Map<String, dynamic> arguments}) {
    if (Get.find<PlatformController>().isMobile) {
      Get.to(
        () => widget,
        preventDuplicates: preventDuplicates ?? false,
        arguments: arguments,
      );
    } else {
      Get.to(
        () => TabletLayout(contentView: widget),
        transition: Transition.noTransition,
        preventDuplicates: preventDuplicates ?? false,
        arguments: arguments,
      );
    }
  }

  void off(Widget widget,
      {bool preventDuplicates, Map<String, dynamic> arguments}) {
    if (Get.find<PlatformController>().isMobile) {
      Get.off(
        () => widget,
        preventDuplicates: preventDuplicates ?? false,
        arguments: arguments,
      );
    } else {
      Get.off(
        () => TabletLayout(contentView: widget),
        transition: Transition.noTransition,
        preventDuplicates: preventDuplicates ?? false,
        arguments: arguments,
      );
    }
  }
}
