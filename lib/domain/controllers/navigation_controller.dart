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
import 'package:projects/internal/pages_setup.dart';
import 'package:projects/presentation/views/fullscreen_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';

class NavigationController extends GetxController {
  final tabIndex = 0.obs;
  final onMoreView = false.obs;
  final selfUserItem = Rx(PortalUserItemController(portalUser: PortalUser()));
  final platformController = Get.find<PlatformController>();

  late bool isMobile;
  int treeLength = 0;

  @override
  void onInit() {
    Get.find<UserController>().getUserInfo().then((value) => selfUserItem.value =
        PortalUserItemController(portalUser: Get.find<UserController>().user.value!));
    isMobile = platformController.isMobile;
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
    String? page, // изменить имя на page
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
        // почему бы для универсальности не добавить?
        return await Get.toNamed(page!);
    } else if (ModalNavigationData.key!.currentState == null) {
      return await toModalScreen(
        modalNavigationData: ModalNavigationData(initialPage: page!),
        arguments: arguments,
      );
    } else
      return await Get.toNamed(page!,
          id: ModalNavigationData.nestedNavigatorId, arguments: arguments);
  }

  Future<void> toModalScreen(
      {required ModalNavigationData modalNavigationData, Map<String, dynamic>? arguments}) async {
    await Get.dialog(
      ModalScreenViewSkeleton(
        modalNavigationData: modalNavigationData,
      ),
      arguments: arguments,
    );
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

mixin NavigationMixin {
  final _navigationController = Get.find<NavigationController>();

  void back<T>({
    bool closeTabletModalScreen = false,
    T? result,
  }) =>
      _navigationController.back(result: result);
}

// const ModalNavigationData({
//   required this.id,
//   required this.onGenerateRoute,
// });

// ModalNavigationData.general()
//     : this(
//           id: Get.nestedKey(1),
//           onGenerateRoute: (settings) {
//             final getPage = getxPages().firstWhere((getPage) => getPage.name == settings.name);
//             return GetPageRoute(page: getPage.page);
//           });

//   ModalNavigationData.settingsRouting()
//       : this(
//             id: Get.nestedKey(SettingsRouteNames.key),
//             onGenerateRoute: (settings) {
//               if (settings.name == SettingsRouteNames.settingsScreen) {
//                 return GetPageRoute(
//                   page: () => const SettingsScreen(),
//                 );
//               } else if (settings.name == SettingsRouteNames.themeSettingsScreen) {
//                 return GetPageRoute(
//                   page: () => const ColorThemeSelectionScreen(),
//                 );
//               } else if (settings.name == SettingsRouteNames.passcodeSettingsScreen) {
//                 return GetPageRoute(
//                   page: () => const PasscodeSettingsScreen(),
//                 );
//               } else if (settings.name == SettingsRouteNames.analyticsSettingsScreen) {
//                 return GetPageRoute(
//                   page: () => const AnalyticsScreen(),
//                 );
//               } else
//                 return null;
//             });
//
//   ModalNavigationData.documentsFilterRouting()
//       : this(
//             id: Get.nestedKey(DocumentsFilterRouteNames.key),
//             onGenerateRoute: (settings) {
//               if (settings.name == DocumentsFilterRouteNames.filter) {
//                 return GetPageRoute(
//                   page: () => const DocumentsFilterScreen(),
//                 );
//               } else if (settings.name == DocumentsFilterRouteNames.filterGroups) {
//                 return GetPageRoute(
//                   page: () => const SelectGroupScreen(),
//                 );
//               } else if (settings.name == DocumentsFilterRouteNames.filterUsers) {
//                 return GetPageRoute(
//                   page: () => const SelectUserScreen(),
//                 );
//               } else
//                 return null;
//             });
//
//   ModalNavigationData.discussionsFilterRouting()
//       : this(
//             id: Get.nestedKey(DiscussionsFilterRouteNames.key),
//             onGenerateRoute: (settings) {
//               if (settings.name == DiscussionsFilterRouteNames.filter) {
//                 return GetPageRoute(
//                   page: () => const DiscussionsFilterScreen(),
//                 );
//               } else if (settings.name == DiscussionsFilterRouteNames.filterAuthor) {
//                 return GetPageRoute(
//                   page: () => const SelectUserScreen(navigatorId: DiscussionsFilterRouteNames.key),
//                 );
//               } else if (settings.name == DiscussionsFilterRouteNames.filterCustomPeriod) {
//                 return GetPageRoute(
//                   page: () => const PasscodeSettingsScreen(),
//                 );
//               } else if (settings.name == DiscussionsFilterRouteNames.filterOtherProjects) {
//                 return GetPageRoute(
//                   page: () => const AnalyticsScreen(),
//                 );
//               } else if (settings.name == DiscussionsFilterRouteNames.filterWithTag) {
//                 return GetPageRoute(
//                   page: () => const AnalyticsScreen(),
//                 );
//               } else
//                 return null;
//             });
//
// }
//
// mixin NestedNavigatorId {
//   static const key = 0;
// }
//
// abstract class SettingsRouteNames with NestedNavigatorId{
//   static const key = 1;
//   static const settingsScreen = '/';
//   static const themeSettingsScreen = '/theme_settings';
//   static const passcodeSettingsScreen = '/passcode_settings';
//   static const analyticsSettingsScreen = '/analytics_settings';
// }
//
// abstract class DocumentsFilterRouteNames with NestedNavigatorId {
//   static const key = 2;
//   static const filter = '/';
//   static const filterUsers = '/filter_users';
//   static const filterGroups = '/filter_groups';
// }
//
// abstract class DiscussionsFilterRouteNames with NestedNavigatorId {
//   static const key = 3;
//   static const filter = '/';
//   static const filterAuthor = '/author';
//   static const filterCustomPeriod = '/custom_period';
//   static const filterOtherProjects = '/other_projects';
//   static const filterWithTag = '/with_tag';
// }
