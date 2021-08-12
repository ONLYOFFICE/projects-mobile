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
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

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
    if (group.isSelected.value == true) {
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
