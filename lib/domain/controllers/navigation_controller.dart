import 'dart:async';

import 'package:event_hub/event_hub.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/fullscreen_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';

class NavigationController extends GetxController {
  var tabIndex = 0.obs;
  var onMoreView = false.obs;
  final _userController = Get.find<UserController>();
  Rx<PortalUserItemController> selfUserItem = PortalUserItemController().obs;

  int treeLength = 0;

  @override
  void onInit() {
    _userController
        .getUserInfo()
        .then((value) => selfUserItem.value =
            PortalUserItemController(portalUser: _userController.user))
        .obs;

    super.onInit();
  }

  @override
  void onClose() {
    // clearCurrentIndex();
    super.onClose();
  }

  void showMoreView() {
    onMoreView.value = true;
    locator<EventHub>().fire('moreViewVisibilityChanged', onMoreView.value);
  }

  void hideMoreView() {
    onMoreView.value = false;
    locator<EventHub>().fire('moreViewVisibilityChanged', onMoreView.value);
  }

  void changeTabIndex(int index) {
    if (index < 3) {
      if (tabIndex.value == index)
        tabIndex.refresh();
      else
        tabIndex.value = index;
      hideMoreView();
    } else {
      if (index == 3) {
        if (!onMoreView.value) {
          showMoreView();
          tabIndex.refresh();
        } else {
          hideMoreView();
          tabIndex.refresh();
        }
      } else {
        hideMoreView();
        if (tabIndex.value == index)
          tabIndex.refresh();
        else
          tabIndex.value = index;
      }
    }
  }

  void changeTabletIndex(int index) {
    tabIndex.value = index;
  }

  void clearCurrentIndex() => tabIndex.value = 0;

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
      treeLength++;
      Get.to(
        () => TabletLayout(contentView: widget),
        transition: Transition.noTransition,
        preventDuplicates: preventDuplicates ?? false,
        arguments: arguments,
      );
    }
  }
}
