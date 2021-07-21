import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';

abstract class DiscussionActionsController {
  RxString text;
  RxString title;
  var selectedProjectTitle;
  RxList subscribers;

  FocusNode get titleFocus => FocusNode();
  TextEditingController _titleController;
  TextEditingController _userSearchController;
  TextEditingController get titleController => _titleController;
  TextEditingController get userSearchController => _userSearchController;
  Rx<TextEditingController> textController;

  var setTitleError;
  var setTextError;
  var selectProjectError;

  void setupSubscribersSelection();
  void addSubscriber(PortalUserItemController user,
      {fromUsersDataSource = false});

  void changeTitle(String newText);
  void changeProjectSelection();

  void clearUserSearch();
  void confirmText();
  void leaveTextView();
  void confirmSubscribersSelection();
  void leaveSubscribersSelectionView();

  void confirmGroupSelection();
  void selectGroupMembers(PortalGroupItemController group);

  DiscussionActionsController();
}
