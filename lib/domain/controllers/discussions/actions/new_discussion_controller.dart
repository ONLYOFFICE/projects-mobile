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
import 'package:event_hub/event_hub.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/enums/user_status.dart';
import 'package:projects/data/models/from_api/new_discussion_DTO.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_detailed.dart';

class NewDiscussionController extends DiscussionActionsController {
  final DiscussionsService _api = locator<DiscussionsService>();

  int? _selectedProjectId;
  int? get selectedProjectId => _selectedProjectId;

  bool _projectIsLocked = false;

  // final _userController = Get.find<UserController>();
  final UserService _userService = locator<UserService>();
  final _usersDataSource = Get.find<UsersDataSource>();
  final navigationController = Get.find<NavigationController>();
  List<PortalGroupItemController> selectedGroups = <PortalGroupItemController>[];
  final _manualSelectedPersons = [];

  final _titleController = TextEditingController();
  final _userSearchController = TextEditingController();
  final _titleFocus = FocusNode();

  @override
  TextEditingController get titleController => _titleController;

  @override
  TextEditingController get userSearchController => _userSearchController;

  @override
  FocusNode get titleFocus => _titleFocus;

  var _team = [];
  var _previousSelectedSubscribers = []; // to track changes

  NewDiscussionController({int? projectId, String? projectTitle}) {
    if (projectId != null && projectTitle != null) {
      _selectedProjectId = projectId;
      selectedProjectTitle.value = projectTitle;

      _projectIsLocked = true;

      addTeam();
    }

    titleController.addListener(() => {titleIsEmpty.value = titleController.text.isEmpty});
  }

  @override
  void onInit() {
    _titleFocus.requestFocus();

    super.onInit();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  void changeTitle(String newText) => title.value = newText;

  @override
  void changeProjectSelection(ProjectDetailed? _details) {
    if (_projectIsLocked) return;
    if (_details != null) {
      selectedProjectTitle.value = _details.title!;
      _selectedProjectId = _details.id;
      selectProjectError.value = false;

      saveManualSelectedPersons();
      subscribers.clear();
      addTeam();
    } else {
      removeProjectSelection();
    }
    navigationController.back();
  }

  void addTeam() {
    if (_selectedProjectId == null) return;

    final team = Get.find<ProjectTeamController>()..setup(projectId: _selectedProjectId);

    team.getTeam().then((value) {
      _team = List.of(team.usersList);
      for (final item in team.usersList) {
        if (item.portalUser.status != null && item.portalUser.status != UserStatus.Terminated) {
          item.selectionMode.value = UserSelectionMode.Multiple;
          item.isSelected.value = true;
          addSubscriber(item);
        }
      }
      _previousSelectedSubscribers = List.of(subscribers);
    });
  }

  void removeProjectSelection() {
    if (_projectIsLocked) return;
    _selectedProjectId = null;
    selectedProjectTitle.value = '';
  }

  @override
  void confirmSubscribersSelection() {
    for (final user in _usersDataSource.usersList) {
      if (!subscribers.any((it) => it.id == user.id) && user.isSelected.value) {
        subscribers.add(user);
      }
    }

    _previousSelectedSubscribers = List.of(subscribers);
    clearUserSearch();
    navigationController.back();
  }

  @override
  void leaveSubscribersSelectionView() {
    if (listEquals(_previousSelectedSubscribers, subscribers)) {
      navigationController.back();
    } else {
      Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        acceptColor: Theme.of(Get.context!).colors().colorError,
        onAcceptTap: () {
          subscribers.value = RxList.from(_previousSelectedSubscribers);
          clearUserSearch();
          Get.back();
          navigationController.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  @override
  Future<void> setupSubscribersSelection() async {
    _usersDataSource.applyUsersSelection = _getSelectedSubscribers;
    await _usersDataSource.getProfiles(needToClear: true);
    restoreManualSelectedPersons();
  }

  void saveManualSelectedPersons() {
    _manualSelectedPersons.clear();
    for (final user in _usersDataSource.usersList) {
      if (user.isSelected.value && !_team.any((it) => it.id == user.id)) {
        _manualSelectedPersons.add(user);
      }
    }
  }

  void restoreManualSelectedPersons() {
    for (final manual in _manualSelectedPersons) {
      for (final user in _usersDataSource.usersList) {
        if (user.id == manual.id) user.isSelected.value = true;
      }
    }
  }

  Future<void> _getSelectedSubscribers() async {
    _usersDataSource.usersList
        .removeWhere((item) => item.portalUser.status == UserStatus.Terminated);

    for (final element in _usersDataSource.usersList) {
      element.isSelected.value = false;
      element.selectionMode.value = UserSelectionMode.Multiple;
    }
    for (final selectedMember in subscribers) {
      for (final user in _usersDataSource.usersList) {
        if (selectedMember.portalUser.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      }
    }
  }

  @override
  void addSubscriber(PortalUserItemController user, {fromUsersDataSource = false}) {
    if (user.isSelected.value == true && !subscribers.any((it) => it.id == user.id)) {
      subscribers.add(user);
      user.isSelected.value = true;
    } else {
      subscribers.removeWhere((element) => user.portalUser.id == element.portalUser.id);
      user.isSelected.value = false;
    }
  }

  @override
  void selectGroupMembers(PortalGroupItemController group) {
    if (group.isSelected.value == true) {
      print(group.portalGroup!.id);
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
            final user = PortalUserItemController(portalUser: element);
            user.isSelected.value = true;
            subscribers.add(user);
          }
        }
      }
    }

    subscribers.value = subscribers.distinct((d) => d.portalUser.id!).toList();
    await _getSelectedSubscribers();
    await _usersDataSource.updateUsers();

    navigationController.back();
  }

  @override
  void clearUserSearch() {
    _userSearchController.clear();
    _usersDataSource.clearSearch();
  }

  Future<void> confirm() async {
    if (_selectedProjectId == null) selectProjectError.value = true;

    title.value = title.value.trim();
    titleController.text = titleController.text.trim();
    if (title.isEmpty) setTitleError.value = true;

    if (text.isEmpty) setTextError.value = true;

    if (selectProjectError.value || setTitleError.value || setTextError.value) {
      unawaited(900.milliseconds.delay().then((value) {
        selectProjectError.value = false;
        setTitleError.value = false;
        setTextError.value = false;
      }));
      return;
    }

    // ignore: omit_local_variable_types
    final List<String?> subscribersIds = [];

    for (final item in subscribers) {
      subscribersIds.add(item.id);
    }

    final newDiss = NewDiscussionDTO(
      content: text.value,
      title: title.value,
      participants: subscribersIds,
    );

    final createdDiss = await _api.addMessage(
      projectId: _selectedProjectId!,
      newDiscussion: newDiss,
    );

    if (createdDiss != null) {
      navigationController.back();

      final discussionController = Get.put<DiscussionItemController>(DiscussionItemController(),
          tag: createdDiss.id.toString());
      discussionController.setup(createdDiss);
      locator<EventHub>().fire('needToRefreshDiscussions', {'all': true});

      MessagesHandler.showSnackBar(
          context: Get.context!,
          text: tr('discussionCreated'),
          buttonText: tr('open').toUpperCase(),
          buttonOnTap: () {
            return Get.find<NavigationController>()
                .to(DiscussionDetailed(), arguments: {'controller': discussionController});
          });
    } else
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
  }

  void discardDiscussion() {
    if ((_selectedProjectId != null && !_projectIsLocked) ||
        title.isNotEmpty ||
        subscribers.isNotEmpty ||
        text.isNotEmpty) {
      Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('discardDiscussion'),
        contentText: tr('changesWillBeLost'),
        acceptText: tr('discard'),
        acceptColor: Theme.of(Get.context!).colors().colorError,
        onAcceptTap: () {
          Get.back();
          navigationController.back();
        },
        onCancelTap: Get.back,
      ));
    } else {
      navigationController.back(closeTabletModalScreen: true);
    }
  }

  @override
  void removeSubscriber(PortalUserItemController user) {}
}
