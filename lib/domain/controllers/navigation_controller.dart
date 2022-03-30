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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/presentation/views/fullscreen_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';
import 'package:projects/presentation/views/settings/analytics_screen.dart';
import 'package:projects/presentation/views/settings/color_theme_selection_screen.dart';
import 'package:projects/presentation/views/settings/passcode/screens/passcode_settings_screen.dart';
import 'package:projects/presentation/views/settings/settings_screen.dart';

class NavigationController extends GetxController {
  final tabIndex = 0.obs;
  final onMoreView = false.obs;
  final selfUserItem = Rx(PortalUserItemController(portalUser: PortalUser()));
  final platformController = Get.find<PlatformController>();

  int treeLength = 0;

  @override
  void onInit() {
    Get.find<UserController>().getUserInfo().then((value) => selfUserItem.value =
        PortalUserItemController(portalUser: Get.find<UserController>().user.value!));

    super.onInit();
  }

  void showMoreView() {
    onMoreView.value = true;
  }

  void hideMoreView() {
    onMoreView.value = false;
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
    update();
  }

  void changeTabletIndex(int index) {
    if (tabIndex.value == index)
      tabIndex.refresh();
    else
      tabIndex.value = index;
  }

  void clearCurrentIndex() => tabIndex.value = 0;

  Future toScreen(
    Widget? widget, {
    bool? preventDuplicates,
    Map<String, dynamic>? arguments,
    Transition? transition,
    bool? popGesture,
    bool fullscreenDialog = false,
    bool isRootModalScreenView = true,
    ModalNavigationData? modalNavigationData,
  }) async {
    if (platformController.isMobile) {
      assert(widget != null, 'Widget must not be null for mobile layout');
      await Get.to(
        () => widget!,
        preventDuplicates: preventDuplicates ?? false,
        fullscreenDialog: fullscreenDialog,
        arguments: arguments,
        transition: transition ?? Transition.downToUp,
        popGesture: popGesture,
      );
    } else if (modalNavigationData != null) {
      await toModalScreen(modalNavigationData: modalNavigationData);
    } else {
      await Get.dialog(
        ModalScreenView(contentView: widget!),
        barrierDismissible: false,
        barrierColor: isRootModalScreenView ? null : Colors.transparent,
        arguments: arguments,
      );
    }
  }

  Future<void> toModalScreen({required ModalNavigationData modalNavigationData}) async {
    await Get.dialog(ModalScreenViewSkeleton(
      modalNavigationData: modalNavigationData,
    ));
  }

  Future to(
    Widget widget, {
    bool? preventDuplicates,
    Map<String, dynamic>? arguments,
    Transition? transition,
    bool? popGesture,
    bool fullscreenDialog = false,
    ModalNavigationData? modalNavigationData,
  }) async {
    if (platformController.isMobile) {
      await Get.to(
        () => widget,
        popGesture: popGesture,
        fullscreenDialog: fullscreenDialog,
        preventDuplicates: preventDuplicates ?? false,
        arguments: arguments,
        transition: transition ?? Transition.rightToLeft,
      );
    } else if (modalNavigationData != null) {
      await toModalScreen(modalNavigationData: modalNavigationData);
    } else {
      treeLength++;
      await Get.to(
        () => TabletLayout(contentView: widget),
        transition: Transition.noTransition,
        preventDuplicates: preventDuplicates ?? false,
        arguments: arguments,
      );
    }
  }

  void back({int? id}) {
    if (id != null && !platformController.isMobile) {
      Get.back(id: id);
    } else {
      Get.back();
    }
  }
}

class ModalNavigationData {
  final GlobalKey<NavigatorState>? id;
  final Route? Function(RouteSettings)? onGenerateRoute;

  const ModalNavigationData({
    required this.id,
    this.onGenerateRoute,
  });

  ModalNavigationData.settingsRouting()
      : this(
            id: Get.nestedKey(SettingsRouteNames.key),
            onGenerateRoute: (settings) {
              if (settings.name == SettingsRouteNames.settingsScreen) {
                return GetPageRoute(
                  page: () => const SettingsScreen(),
                );
              } else if (settings.name == SettingsRouteNames.themeSettingsScreen) {
                return GetPageRoute(
                  page: () => const ColorThemeSelectionScreen(),
                );
              } else if (settings.name == SettingsRouteNames.passcodeSettingsScreen) {
                return GetPageRoute(
                  page: () => const PasscodeSettingsScreen(),
                );
              } else if (settings.name == SettingsRouteNames.analyticsSettingsScreen) {
                return GetPageRoute(
                  page: () => const AnalyticsScreen(),
                );
              } else
                return null;
            });
}

abstract class SettingsRouteNames {
  static const key = 1;
  static const settingsScreen = '/';
  static const themeSettingsScreen = '/theme_settings';
  static const passcodeSettingsScreen = '/passcode_settings';
  static const analyticsSettingsScreen = '/analytics_settings';
}
