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

import 'package:darq/darq.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/enums/user_status.dart';
import 'package:projects/data/models/from_api/new_discussion_DTO.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/services/discussion_item_service.dart';
import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class DiscussionEditingController extends DiscussionActionsController {
  int id;
  int projectId;

  String _previusTitle = '';
  String _previusText = '';

  List<PortalUser> initialSubscribers = <PortalUser>[];
  List<PortalUserItemController> _previusSelectedSubscribers = <PortalUserItemController>[];

  final _api = locator<DiscussionItemService>();

  final _userService = locator<UserService>();
  final _usersDataSource = Get.find<UsersDataSource>();
  final selectedGroups = <PortalGroupItemController>[];

  final _titleController = TextEditingController();
  final _userSearchController = TextEditingController();
  final _titleFocus = FocusNode();

  @override
  TextEditingController get titleController => _titleController;
  @override
  TextEditingController get userSearchController => _userSearchController;
  @override
  FocusNode get titleFocus => _titleFocus;

  @override
  void onInit() {
    titleController.text = title.value;

    for (final item in initialSubscribers) {
      final pu = PortalUserItemController(portalUser: item, isSelected: true);
      pu.selectionMode.value = UserSelectionMode.Multiple;
      subscribers.add(pu);
    }
    _previusSelectedSubscribers = List.from(subscribers);
    _previusText = text.value;
    _previusTitle = title.value;

    super.onInit();
  }

  DiscussionEditingController({
    this.id = -1,
    required String title,
    required String text,
    this.projectId = -1,
    required String selectedProjectTitle,
    required this.initialSubscribers,
  }) {
    this.title.value = title;
    this.text.value = text;
    this.selectedProjectTitle.value = selectedProjectTitle;

    _usersDataSource.selectionMode = UserSelectionMode.Multiple;

    titleController.addListener(() => {titleIsEmpty.value = titleController.text.isEmpty});
  }

  @override
  void changeTitle(String newText) => title.value = newText;

  @override
  void changeProjectSelection(ProjectDetailed? _details) {}

  @override
  void confirmSubscribersSelection() {
    // ignore: invalid_use_of_protected_member
    _previusSelectedSubscribers = List.from(subscribers);
    clearUserSearch();
    Get.find<NavigationController>().back();
  }

  @override
  void leaveSubscribersSelectionView() {
    // ignore: invalid_use_of_protected_member
    if (listEquals(_previusSelectedSubscribers, subscribers.value)) {
      clearUserSearch();
      Get.find<NavigationController>().back();
    } else {
      Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        acceptColor: Theme.of(Get.context!).colors().colorError,
        onAcceptTap: () {
          for (final item in _previusSelectedSubscribers) {
            if (!item.isSelected.value) item.isSelected.value = true;
          }
          subscribers.value = List.from(_previusSelectedSubscribers);
          clearUserSearch();
          Get.back();
          Get.find<NavigationController>().back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  @override
  Future<void> setupSubscribersSelection() async {
    _usersDataSource.applyUsersSelection = _getSelectedSubscribers;
    await _usersDataSource.getProfiles(needToClear: true, withoutSelf: false);
  }

  Future<void> _getSelectedSubscribers() async {
    _usersDataSource.usersList
        .removeWhere((item) => item.portalUser.status == UserStatus.Terminated);

    otherUsers.clear();
    otherUsers.addAll(_usersDataSource.usersList
        .where((element) => !subscribers.any((it) => it.id == element.id))
        .toList());

    for (final user in _usersDataSource.usersList) {
      if (subscribers.any((it) => it.id == user.id)) user.isSelected.value = true;
    }

    for (final user in otherUsers) {
      user.selectionMode.value = UserSelectionMode.Multiple;
    }
  }

  @override
  void addSubscriber(PortalUserItemController user, {bool fromUsersDataSource = false}) {
    if (!fromUsersDataSource) {
      user.isSelected.value = true;
      otherUsers.removeWhere((element) => user.portalUser.id == element.portalUser.id);
      subscribers.add(user);

      sortLists();
    } else {
      // the items in usersDataSource have their own onTap functions,
      // so the value of IsSelected has already been changed
      if (user.isSelected.value == false) {
        subscribers.removeWhere((element) => user.portalUser.id == element.portalUser.id);
        sortLists();
      } else {
        subscribers.add(user);
        sortLists();
      }
    }
  }

  @override
  void removeSubscriber(PortalUserItemController user) {
    user.isSelected.value = false;
    subscribers.removeWhere((element) => user.portalUser.id == element.portalUser.id);
    otherUsers.add(user);
    otherUsers.removeWhere((item) => item.portalUser.status == UserStatus.Terminated);
    sortLists();
  }

  void sortLists() {
    otherUsers.sort((a, b) {
      return a.portalUser.displayName!
          .toLowerCase()
          .compareTo(b.portalUser.displayName!.toLowerCase());
    });

    subscribers.sort((a, b) {
      return a.portalUser.displayName!
          .toLowerCase()
          .compareTo(b.portalUser.displayName!.toLowerCase());
    });
  }

  @override
  void selectGroupMembers(PortalGroupItemController group) {
    if (selectedGroups.any((element) => element.displayName == group.displayName)) return;

    if (group.isSelected.value) {
      selectedGroups.add(group);
    } else {
      selectedGroups.removeWhere((element) => group.portalGroup!.id == element.portalGroup!.id);
    }
  }

  @override
  Future<void> confirmGroupSelection() async {
    for (final group in selectedGroups) {
      final groupMembers =
          await _userService.getProfilesByExtendedFilter(groupId: group.portalGroup!.id);

      if (groupMembers != null) {
        if (groupMembers.response!.isNotEmpty) {
          for (final element in groupMembers.response!) {
            final user = PortalUserItemController(
                portalUser: element, isSelected: true, selectionMode: UserSelectionMode.Multiple);

            subscribers.add(user);
          }
        }
      }
    }

    subscribers.value = subscribers.distinct((d) => d.portalUser.id!).toList();
    await _getSelectedSubscribers();
    await _usersDataSource.updateUsers();

    Get.find<NavigationController>().back();
  }

  @override
  void clearUserSearch() {
    _userSearchController.clear();
    _usersDataSource.clearSearch();
  }

  Future<void> confirm(BuildContext context) async {
    title.value = title.value.trim();
    titleController.text = titleController.text.trim();
    if (title.isEmpty) setTitleError.value = true;

    if (text.isEmpty) setTextError.value = true;

    if (title.isNotEmpty && text.isNotEmpty) {
      final subscribersIds = <String?>[];

      for (final item in subscribers) subscribersIds.add(item.id);

      final diss = NewDiscussionDTO(
        content: text.value,
        title: title.value,
        participants: subscribersIds,
        projectId: projectId,
      );

      final editedDiss = await _api.updateMessage(
        id: id,
        discussion: diss,
      );

      if (editedDiss != null) {
        clearUserSearch();

        final discussionController = Get.find<DiscussionItemController>(tag: id.toString());
        unawaited(discussionController.onRefresh());

        final discussionsController = Get.find<DiscussionsController>(tag: 'DiscussionsView');
        unawaited(discussionsController.loadDiscussions());

        Get.find<NavigationController>().back();
      }
    }
  }

  void discardDiscussion() {
    if (title.value != _previusTitle || text.value != _previusText) {
      Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('discardDiscussion'),
        contentText: tr('changesWillBeLost'),
        acceptText: tr('discard'),
        acceptColor: Theme.of(Get.context!).colors().colorError,
        onAcceptTap: () {
          Get.back();
          Get.find<NavigationController>().back();
        },
        onCancelTap: Get.back,
      ));
    } else {
      Get.find<NavigationController>().back();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}
