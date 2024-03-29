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
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/internal/pages_setup.dart';
import 'package:projects/presentation/views/fullscreen_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';

class NavigationController extends GetxController {
  final tabIndex = 0.obs;
  final onMoreView = false.obs;

  final isMobile = Get.find<PlatformController>().isMobile;
  int treeLength = 0;

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
    String? page,
  }) async {
    if (isMobile) {
      if (widget != null)
        return await Get.to(
          () => widget,
          preventDuplicates: preventDuplicates ?? false,
          fullscreenDialog: fullscreenDialog,
          arguments: arguments,
          transition: transition ?? Transition.native,
          popGesture: popGesture,
        );
      else
        return await Get.toNamed(
          page!,
          arguments: arguments,
          preventDuplicates: preventDuplicates ?? false,
        );
    } else if (ModalNavigationData.key!.currentState == null) {
      return await toModalScreen(
        modalNavigationData: ModalNavigationData(initialPage: page!),
        arguments: arguments,
      );
    } else
      return await Get.toNamed(
        page!,
        id: ModalNavigationData.nestedNavigatorId,
        arguments: arguments,
        preventDuplicates: preventDuplicates ?? false,
      );
  }

  Future<void> toModalScreen(
      {required ModalNavigationData modalNavigationData, Map<String, dynamic>? arguments}) async {
    await showPlatformDialog(ModalScreenViewSkeleton(modalNavigationData: modalNavigationData),
        arguments: arguments);
  }

  Future<T?> showPlatformDialog<T>(
    Widget widget, {
    Object? arguments,
    bool? barrierDismissible,
  }) async {
    final _route = DialogRoute(
      builder: (_) => widget,
      settings: RouteSettings(arguments: arguments),
      context: Get.context!,
      barrierDismissible: barrierDismissible ?? false,
    );
    final result = await Navigator.of(Get.context!).push(_route);
    return result as T?;
  }

  Future to(
    Widget widget, {
    bool? preventDuplicates,
    Map<String, dynamic>? arguments,
    Transition? transition,
    bool? popGesture,
    bool fullscreenDialog = false,
  }) async {
    if (isMobile) {
      return await Get.to(
        () => widget,
        popGesture: popGesture,
        fullscreenDialog: fullscreenDialog,
        preventDuplicates: preventDuplicates ?? false,
        arguments: arguments,
        transition: transition ?? Transition.native,
      );
    } else {
      treeLength++;
      return await Get.to(
        () => TabletLayout(contentView: widget),
        transition: Transition.noTransition,
        preventDuplicates: preventDuplicates ?? false,
        arguments: arguments,
      );
    }
  }

  void back<T>({
    bool closeTabletModalScreen = false,
    T? result,
  }) {
    final canPop = ModalNavigationData.key?.currentState?.canPop();
    if (canPop == true) {
      Get.back(id: ModalNavigationData.nestedNavigatorId, result: result);
    } else {
      Get.back(result: result);
    }
  }

  void close(int times) {
    for (var i = 0; i < times; i++) back();
  }
}

class ModalNavigationData {
  static const nestedNavigatorId = 1;

  static final _pages = getxPages();

  static Route onGenerateRoute(RouteSettings settings) {
    final getPage = _pages.firstWhere((getPage) => getPage.name == settings.name);
    return GetPageRoute(page: getPage.page, settings: settings);
  }

  static List<Route<dynamic>> onGenerateInitialRoutes(_, initialRouteName) {
    final getPage = _pages.firstWhere((getPage) => getPage.name == initialRouteName);
    return [GetPageRoute(page: getPage.page)];
  }

  static GlobalKey<NavigatorState>? get key => Get.nestedKey(nestedNavigatorId);

  String initialPage;

  ModalNavigationData({
    required this.initialPage,
  });
}
