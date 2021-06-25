import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:darq/darq.dart';

import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/new_discussion_DTO.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/discussions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled_snackbar.dart';

class NewDiscussionController extends GetxController
    implements DiscussionActionsController {
  final _api = locator<DiscussionsService>();
  var _selectedProjectId;
  // for dateTime format
  DateTime _startDate;
  DateTime _dueDate;

  int get selectedProjectId => _selectedProjectId;
  DateTime get startDate => _startDate;
  DateTime get dueDate => _dueDate;

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
    super.onInit();
  }

  @override
  void changeTitle(String newText) => title.value = newText;

  @override
  void changeProjectSelection({var id, String title}) {
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
        titleText: 'Discard changes?',
        contentText: 'If you leave, all changes will be lost.',
        acceptText: 'DELETE',
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
        titleText: 'Discard changes?',
        contentText: 'If you leave, all changes will be lost.',
        acceptText: 'DELETE',
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
    await _usersDataSource.getProfiles(needToClear: true);
    _usersDataSource.withoutSelf = false;
  }

  Future<void> _getSelectedSubscribers() async {
    for (var element in _usersDataSource.usersList) {
      element.isSelected.value = false;
      element.selectionMode.value = UserSelectionMode.Multiple;
      for (var selectedMember in subscribers) {
        for (var user in _usersDataSource.usersList) {
          if (selectedMember.portalUser.id == user.portalUser.id) {
            user.isSelected.value = true;
          }
        }
      }
    }
  }

  @override
  void addSubscriber(PortalUserItemController user) {
    if (user.isSelected.isTrue) {
      subscribers.add(user);
    } else {
      subscribers.removeWhere(
          (element) => user.portalUser.id == element.portalUser.id);
    }
  }

  void selectGroupMembers(PortalGroupItemController group) {
    if (group.isSelected.isTrue) {
      print(group.portalGroup.id);
      selectedGroups.add(group);
    } else {
      selectedGroups.removeWhere(
          (element) => group.portalGroup.id == element.portalGroup.id);
    }
  }

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
        var tasksController = Get.find<DiscussionsController>();
        // ignore: unawaited_futures
        tasksController.loadDiscussions();
        Get.back();
        // ignore: unawaited_futures
        ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
            context: context,
            text: 'Discussion had been created',
            buttonText: 'OPEN',
            buttonOnTap: () {
              return Get.toNamed('DiscussionDetailed',
                  arguments: {'discussion': createdDiss});
            }));
      }
    }
  }

  void discardDiscussion() {
    if (_selectedProjectId != null ||
        title.isNotEmpty ||
        subscribers.isNotEmpty ||
        text.isNotEmpty ||
        _startDate != null ||
        _dueDate != null) {
      Get.dialog(StyledAlertDialog(
        titleText: 'Discard discussion?',
        contentText: 'Your changes will not be saved.',
        acceptText: 'DISCARD',
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