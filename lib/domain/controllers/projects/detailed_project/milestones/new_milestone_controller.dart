import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/new_milestone_DTO.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/new_task/select/select_date_view.dart';
import 'package:projects/presentation/views/new_task/select/select_project_view.dart';

class NewMilestoneController extends GetxController {
  final _api = locator<MilestoneService>();
  var _selectedProjectId;
  DateTime _dueDate;

  var remindBeforeDueDate = false.obs;
  var keyMilestone = false.obs;
  int get selectedProjectId => _selectedProjectId;
  DateTime get dueDate => _dueDate;

  final _userController = Get.find<UserController>();
  final _usersDataSource = Get.find<UsersDataSource>();
  PortalUserItemController selfUserItem;

  RxString slectedProjectTitle = ''.obs;
  RxString slectedMilestoneTitle = ''.obs;

  RxString descriptionText = ''.obs;
  var descriptionController = TextEditingController().obs;

  RxString dueDateText = ''.obs;
  RxBool needToSelectProject = false.obs;
  RxBool needToSetTitle = false.obs;
  RxBool needToSelectResponsible = false.obs;

  var titleController = TextEditingController();

  PortalUserItemController _previusSelectedResponsible;
  Rx<PortalUserItemController> responsible;

  void setup(ProjectDetailed projectDetailed) {
    if (projectDetailed != null) {
      slectedProjectTitle.value = projectDetailed.title;
      _selectedProjectId = projectDetailed.id;
      needToSelectProject.value = false;
    }
  }

  void changeProjectSelection({var id, String title}) {
    if (id != null && title != null) {
      slectedProjectTitle.value = title;
      _selectedProjectId = id;
      needToSelectProject.value = false;
    } else {
      removeProjectSelection();
    }
    Get.back();
  }

  void removeProjectSelection() {
    _selectedProjectId = null;
    slectedProjectTitle.value = '';
  }

  void confirmDescription(String newText) {
    descriptionText.value = newText;
    Get.back();
  }

  void leaveDescriptionView(String typedText) {
    if (typedText == descriptionText.value) {
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        onAcceptTap: () {
          descriptionController.value.text = descriptionText.value;
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  void confirmResponsiblesSelection() {
    _previusSelectedResponsible = responsible.value;
    Get.back();
  }

  void leaveResponsiblesSelectionView() {
    if (_previusSelectedResponsible == null ||
        _previusSelectedResponsible == responsible.value) {
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        onAcceptTap: () {
          responsible.value = _previusSelectedResponsible;
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  void setupResponsibleSelection() async {
    await _userController.getUserInfo();

    var selfUser = _userController.user;
    selfUserItem = PortalUserItemController(portalUser: selfUser);

    selfUserItem.selectionMode.value = UserSelectionMode.Single;
    _usersDataSource.applyUsersSelection = _applyUsersSelection;

    _usersDataSource.withoutSelf = true;
    _usersDataSource.selfUserItem = selfUserItem;

    await _usersDataSource.getProfiles(needToClear: true);
  }

  Future<void> _applyUsersSelection() async {
    for (var element in _usersDataSource.usersList) {
      element.isSelected.value = false;
      element.selectionMode.value = UserSelectionMode.Single;
    }

    if (responsible != null) {
      for (var user in _usersDataSource.usersList) {
        if (responsible.value.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      }

      if (selfUserItem.portalUser.id == responsible.value.portalUser.id) {
        selfUserItem.isSelected.value = responsible.value.isSelected.value;
      }
    }
  }

  void addResponsible(PortalUserItemController user) {
    if (user.isSelected.value == true) {
      responsible = user.obs;
    } else {
      responsible = null;
    }
    if (selfUserItem.portalUser.id == user.portalUser.id) {
      selfUserItem.isSelected.value = user.isSelected.value;
    }
  }

  void changeDueDate(DateTime newDate) {
    if (newDate != null) {
      _dueDate = newDate;
      dueDateText.value = formatedDateFromString(
          now: DateTime.now(), stringDate: newDate.toString());
      Get.back();
    } else {
      _dueDate = null;
      dueDateText.value = '';
    }
  }

  void confirm(BuildContext context) async {
    if (_selectedProjectId == null) needToSelectProject.value = true;
    if (titleController.text.isEmpty) needToSetTitle.value = true;
    if (responsible?.value == null) needToSelectResponsible.value = true;

    if (needToSelectProject.value == false ||
        needToSetTitle.value == false ||
        needToSelectResponsible.value == false) return;

    var milestone = NewMilestoneDTO(
      title: titleController.text,
      description: descriptionController.value.text,
      deadline: dueDate,
      isKey: keyMilestone.value,
      responsible: responsible.value.id,
      isNotify: remindBeforeDueDate.value,
      // notifyResponsible:
    );

    var success = await _api.createMilestone(
        projectId: _selectedProjectId, milestone: milestone);
    if (success) Get.back();
  }

  void discard() {
    if (_selectedProjectId != null ||
        titleController.text.isNotEmpty ||
        responsible != null ||
        descriptionText.isNotEmpty ||
        _dueDate != null) {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardMilestone'),
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

  void setKeyMilestone(value) => keyMilestone.value = value;
  void enableRemindBeforeDueDate(value) => remindBeforeDueDate.value = value;

  void onProjectTilePressed() {
    Get.find<NavigationController>()
        .to(const SelectProjectView(), arguments: {'controller': this});
  }

  void onDueDateTilePressed() {
    Get.find<NavigationController>().to(const SelectDateView(),
        arguments: {'controller': this, 'startDate': false});
  }
}
