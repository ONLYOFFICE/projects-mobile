import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';
import 'package:projects/presentation/views/fullscreen_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';

class NavigationController extends GetxController {
  var tabIndex = 0;
  var onMoreView = false;

  @override
  void onInit() {
    var portalController = Get.find<PortalInfoController>();
    if (portalController.portalName == null) portalController.onInit();
    super.onInit();
  }

  void changeTabIndex(int index) {
    if (index < 3) {
      onMoreView = false;
      tabIndex = index;
      update();
    } else {
      if (index == 3) {
        if (!onMoreView) {
          onMoreView = true;
          update();
        } else {
          onMoreView = false;
          update();
        }
      } else {
        onMoreView = false;
        tabIndex = index;
        update();
      }
    }
  }

  void changeTabletIndex(int index) {
    onMoreView = false;
    tabIndex = index;
    update();
  }

  void clearCurrentIndex() => tabIndex = null;

  void toScreen(Widget widget,
      {bool preventDuplicates, Map<String, dynamic> arguments}) {
    if (Get.find<PlatformController>().isMobile) {
      Get.to(
        () => widget,
        preventDuplicates: preventDuplicates ?? false,
        arguments: arguments,
      );
    } else {
      Get.to(() => ModalScreenView(contentView: widget),
          opaque: false,
          transition: Transition.noTransition,
          preventDuplicates: preventDuplicates ?? false,
          arguments: arguments);
    }
  }

  void to(Widget widget,
      {bool preventDuplicates, Map<String, dynamic> arguments}) {
    if (Get.find<PlatformController>().isMobile) {
      Get.to(
        () => widget,
        preventDuplicates: preventDuplicates ?? true,
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
        preventDuplicates: preventDuplicates ?? true,
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

  // void bottomSheet(Widget widget) {
  //   if (Get.find<PlatformController>().isMobile) {
  //     Get.bottomSheet(
  //       widget,
  //       isScrollControlled: true,
  //     );
  //   } else {
  //     Get.to(() =>
  //       FullscreenView(
  //         contentView: widget,
  //       ),
  //       fullscreenDialog: false,
  //       opaque: false,
  //       transition: Transition.noTransition,
  //     );
  //   }
  // }
}
