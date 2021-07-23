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

import 'package:darq/darq.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/new_discussion_DTO.dart';
import 'package:projects/data/services/discussion_item_service.dart';
import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';

class DiscussionEditingController extends GetxController
    implements DiscussionActionsController {
  DiscussionEditingController({
    this.id,
    this.title,
    this.text,
    this.projectId,
    this.selectedProjectTitle,
    this.initialSubscribers,
  });

  final int id;
  final int projectId;
  @override
  var selectedProjectTitle;
  @override
  RxString title;
  @override
  RxString text;
  @override
  RxList subscribers = [].obs;

  final initialSubscribers;
  List _previusSelectedSubscribers;
  var _previusText;
  var _previusTitle;

  @override
  void onInit() {
    titleController.text = title.value;
    textController.value.text = text.value;
    // ignore: invalid_use_of_protected_member
    for (var item in initialSubscribers) {
      subscribers.add(
          PortalUserItemController(portalUser: item, isSelected: true.obs));
    }
    _previusSelectedSubscribers = List.from(subscribers);
    _previusText = text.value;
    _previusTitle = title.value;
    super.onInit();
  }

  final DiscussionItemService _api = locator<DiscussionItemService>();

  // final _userController = Get.find<UserController>();
  final _userService = locator<UserService>();
  final _usersDataSource = Get.find<UsersDataSource>();
  var selectedGroups = <PortalGroupItemController>[];

  @override
  var textController = TextEditingController().obs;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _userSearchController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();

  @override
  TextEditingController get titleController => _titleController;
  @override
  TextEditingController get userSearchController => _userSearchController;
  @override
  FocusNode get titleFocus => _titleFocus;

  @override
  var selectProjectError = false.obs; //RxBool
  @override
  var setTitleError = false.obs;
  @override
  var setTextError = false.obs;

  @override
  void changeTitle(String newText) => title.value = newText;

  @override
  void changeProjectSelection() => null;

  @override
  void confirmText() {
    text.value = textController.value.text;

    Get.back();
  }

  @override
  void leaveTextView() {
    if (textController.value.text == text.value) {
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        onAcceptTap: () {
          textController.value.text = text.value;

          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  @override
  void confirmSubscribersSelection() {
    // ignore: invalid_use_of_protected_member
    _previusSelectedSubscribers = List.from(subscribers);
    clearUserSearch();
    Get.back();
  }

  @override
  void leaveSubscribersSelectionView() {
    // ignore: invalid_use_of_protected_member
    if (listEquals(_previusSelectedSubscribers, subscribers.value)) {
      clearUserSearch();
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        onAcceptTap: () {
          for (var item in _previusSelectedSubscribers) {
            if (!item.isSelected.value) item.isSelected.value = true;
          }
          subscribers.value = List.from(_previusSelectedSubscribers);
          clearUserSearch();
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  @override
  void setupSubscribersSelection() async {
    await _usersDataSource.getProfiles(needToClear: true);
    _usersDataSource.applyUsersSelection = _getSelectedSubscribers;
    _usersDataSource.withoutSelf = false;
  }

  Future<void> _getSelectedSubscribers() async {
    for (var i = 0; i < _usersDataSource.usersList.length; i++) {
      PortalUserItemController user = _usersDataSource.usersList[i];
      user.selectionMode.value = UserSelectionMode.Multiple;
      var found = false;

      for (var j = 0; j < subscribers.length; j++) {
        if (subscribers[j].id == user.id) {
          subscribers[j] = user;
          found = true;
          break;
        }
      }
      _previusSelectedSubscribers = List.from(subscribers);

      user.isSelected.value = found ? true : false;
    }
  }

  @override
  void addSubscriber(PortalUserItemController user,
      {fromUsersDataSource = false}) {
    if (!fromUsersDataSource) {
      if (user.isSelected.value == false) {
        user.isSelected.value = true;
        subscribers.add(user);
      } else {
        user.isSelected.value = false;
        subscribers.removeWhere(
            (element) => user.portalUser.id == element.portalUser.id);
      }
    } else {
      // the items in usersDataSource have their own onTap functions,
      // so the value of IsSelected has already been changed
      if (user.isSelected.value == false) {
        subscribers.removeWhere(
            (element) => user.portalUser.id == element.portalUser.id);
      } else {
        subscribers.add(user);
      }
    }
  }

  @override
  void selectGroupMembers(PortalGroupItemController group) {
    if (group.isSelected.isTrue) {
      selectedGroups.add(group);
    } else {
      selectedGroups.removeWhere(
          (element) => group.portalGroup.id == element.portalGroup.id);
    }
  }

  @override
  void confirmGroupSelection() async {
    for (var group in selectedGroups) {
      var groupMembers = await _userService.getProfilesByExtendedFilter(
          groupId: group.portalGroup.id);

      if (groupMembers.response.isNotEmpty) {
        for (var element in groupMembers.response) {
          var user = PortalUserItemController(portalUser: element);
          user.isSelected.value = true;
          subscribers.add(user);
        }
      }
    }

    subscribers.value = subscribers.distinct((d) => d.portalUser.id).toList();
    await _getSelectedSubscribers();
    await _usersDataSource.updateUsers();

    Get.back();
  }

  @override
  void clearUserSearch() {
    _userSearchController.clear();
    _usersDataSource.clearSearch();
  }

  void confirm(BuildContext context) async {
    if (title.isEmpty) setTitleError.value = true;
    if (text.isEmpty) setTextError.value = true;
    if (title.isNotEmpty && text.isNotEmpty) {
      // ignore: omit_local_variable_types
      List<String> subscribersIds = [];

      for (var item in subscribers) subscribersIds.add(item.id);

      var diss = NewDiscussionDTO(
        content: text.value,
        title: title.value,
        participants: subscribersIds,
        projectId: projectId,
      );

      var editedDiss = await _api.updateMessage(
        id: id,
        discussion: diss,
      );

      if (editedDiss != null) {
        var discussionsController = Get.find<DiscussionsController>();
        var discussionController = Get.find<DiscussionItemController>();
        clearUserSearch();
        // ignore: unawaited_futures
        discussionController.onRefresh();
        Get.back();
        // ignore: unawaited_futures
        discussionsController.loadDiscussions();
      }
    }
  }

  void discardDiscussion() {
    if (title.value != _previusTitle || text.value != _previusText) {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardDiscussion'),
        contentText: tr('changesWillBeLost'),
        acceptText: tr('discard'),
        onAcceptTap: () {
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    } else {
      Get.back();
    }
  }
}