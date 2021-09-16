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
import 'package:event_hub/event_hub.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:darq/darq.dart';

import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/new_discussion_DTO.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_discussions_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_detailed.dart';

class NewDiscussionController extends GetxController
    implements DiscussionActionsController {
  final specifiedProjectId;
  final specifiedProjectTitle;
  NewDiscussionController(
      {this.specifiedProjectId, this.specifiedProjectTitle});

  final _api = locator<DiscussionsService>();
  var _selectedProjectId;

  int get selectedProjectId => _selectedProjectId;

  // final _userController = Get.find<UserController>();
  final _userService = locator<UserService>();
  final _usersDataSource = Get.find<UsersDataSource>();
  var selectedGroups = <PortalGroupItemController>[];

  @override
  RxString title = ''.obs;

  @override
  var selectedProjectTitle = ''.obs; //RxString

  @override
  RxString text = ''.obs;
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
  RxList subscribers = [].obs;
  // to track changes
  List _previusSelectedSubscribers = [];

  @override
  var selectProjectError = false.obs; //RxBool
  @override
  var setTitleError = false.obs;
  @override
  var setTextError = false.obs;

  @override
  void onInit() {
    _titleFocus.requestFocus();
    if (specifiedProjectId != null) {
      _selectedProjectId = specifiedProjectId;
      selectedProjectTitle.value = specifiedProjectTitle;
    }
    super.onInit();
  }

  @override
  void changeTitle(String newText) => title.value = newText;

  @override
  void changeProjectSelection({var id, String title}) {
    if (specifiedProjectId != null) return;
    if (id != null && title != null) {
      selectedProjectTitle.value = title;
      _selectedProjectId = id;
      selectProjectError.value = false;
    } else {
      removeProjectSelection();
    }
    Get.back();
  }

  void removeProjectSelection() {
    if (specifiedProjectId != null) return;
    _selectedProjectId = null;
    selectedProjectTitle.value = '';
  }

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
    _previusSelectedSubscribers = List.of(subscribers.value);
    clearUserSearch();
    Get.back();
  }

  @override
  void leaveSubscribersSelectionView() {
    // ignore: invalid_use_of_protected_member
    if (listEquals(_previusSelectedSubscribers, subscribers.value)) {
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        onAcceptTap: () {
          subscribers.value = List.of(_previusSelectedSubscribers);
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
    _usersDataSource.applyUsersSelection = _getSelectedSubscribers;
    await _usersDataSource.getProfiles(needToClear: true, withoutSelf: false);
  }

  Future<void> _getSelectedSubscribers() async {
    for (var element in _usersDataSource.usersList) {
      element.isSelected.value = false;
      element.selectionMode.value = UserSelectionMode.Multiple;
    }
    for (var selectedMember in subscribers) {
      for (var user in _usersDataSource.usersList) {
        if (selectedMember.portalUser.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      }
    }
  }

  @override
  void addSubscriber(PortalUserItemController user,
      {fromUsersDataSource = false}) {
    user.onTap();

    if (user.isSelected.value == true) {
      subscribers.add(user);
    } else {
      subscribers.removeWhere(
          (element) => user.portalUser.id == element.portalUser.id);
    }
  }

  @override
  void selectGroupMembers(PortalGroupItemController group) {
    if (group.isSelected.value == true) {
      print(group.portalGroup.id);
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
    if (_selectedProjectId == null) selectProjectError.value = true;
    if (title.isEmpty) setTitleError.value = true;
    if (text.isEmpty) setTextError.value = true;
    if (_selectedProjectId != null && title.isNotEmpty && text.isNotEmpty) {
      // ignore: omit_local_variable_types
      List<String> subscribersIds = [];

      for (var item in subscribers) subscribersIds.add(item.id);

      var newDiss = NewDiscussionDTO(
        content: text.value,
        title: title.value,
        participants: subscribersIds,
      );

      var createdDiss = await _api.addMessage(
        projectId: _selectedProjectId,
        newDiscussion: newDiss,
      );

      if (createdDiss != null) {
        var discussionsController = Get.find<DiscussionsController>();
        // ignore: unawaited_futures
        discussionsController.loadDiscussions();
        if (specifiedProjectId != null) {
          try {
            locator<EventHub>().fire('needToRefreshProjects');

            // ignore: unawaited_futures
            Get.find<ProjectDiscussionsController>().loadProjectDiscussions();
          } catch (e) {
            debugPrint(e);
          }
        }

        Get.back();
        // ignore: unawaited_futures
        MessagesHandler.showSnackBar(
            context: context,
            text: tr('discussionCreated'),
            buttonText: tr('open').toUpperCase(),
            buttonOnTap: () {
              return Get.find<NavigationController>().to(DiscussionDetailed(),
                  arguments: {'discussion': createdDiss});
            });
      }
    }
  }

  void discardDiscussion() {
    if ((_selectedProjectId != null && specifiedProjectId == null) ||
        title.isNotEmpty ||
        subscribers.isNotEmpty ||
        text.isNotEmpty) {
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
