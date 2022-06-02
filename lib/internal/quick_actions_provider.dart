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

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/new_discussion/new_discussion_screen.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/new_project_view.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickActionsProvider {
  void setupQuickAction() {
    const quickActions = QuickActions();
    quickActions.initialize((shortcutType) async {
      switch (shortcutType) {
        case 'newProject':
          Future.delayed(const Duration(milliseconds: 1500), () async {
            final isAuthValid = await locator<AuthService>().checkAuthorization();
            if (isAuthValid)
              await Get.find<NavigationController>().toScreen(
                const NewProject(),
                transition: Transition.cupertinoDialog,
                fullscreenDialog: true,
                page: '/NewProject',
              );
          });
          break;

        case 'newTask':
          Future.delayed(const Duration(milliseconds: 1500), () async {
            final isAuthValid = await locator<AuthService>().checkAuthorization();
            if (isAuthValid)
              await Get.find<NavigationController>().toScreen(
                const NewTaskView(),
                arguments: {'projectDetailed': null},
                page: '/NewTaskView',
              );
          });
          break;
        case 'newDiscussion':
          Future.delayed(const Duration(milliseconds: 1500), () async {
            final isAuthValid = await locator<AuthService>().checkAuthorization();
            if (isAuthValid)
              await Get.find<NavigationController>().toScreen(
                const NewDiscussionScreen(),
                transition: Transition.cupertinoDialog,
                fullscreenDialog: true,
                page: '/NewDiscussionScreen',
              );
          });
          break;
        default:
      }
    });

    final newProject = tr('newProject');
    final newTask = tr('newTask');
    final newDiscussion = tr('newDiscussion');

    quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(type: 'newProject', localizedTitle: newProject, icon: 'icon_project'),
      ShortcutItem(type: 'newTask', localizedTitle: newTask, icon: 'icon_task'),
      ShortcutItem(type: 'newDiscussion', localizedTitle: newDiscussion, icon: 'icon_discussion'),
    ]);
  }
}
