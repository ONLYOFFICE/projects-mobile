import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/data/services/task_service.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/domain/controllers/tasks/abstract_task_actions_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';

class TaskEditingController extends GetxController
    implements TaskActionsController {
  PortalTask task;
  final _api = locator<TaskService>();

  TaskEditingController({@required this.task});

  @override
  RxBool setTitleError = false.obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;

  final TextEditingController _titleController = TextEditingController();
  TaskItemController _taskItemController;

  @override
  RxString title;
  @override
  RxString descriptionText;
  var _newMilestoneId;
  @override
  RxString selectedMilestoneTitle;
  @override
  var selectedProjectTitle; //Unused
  @override
  var selectProjectError = false;
  // to track changes.
  DateTime _newStartDate;
  @override
  RxString startDateText;
  DateTime _newDueDate;
  @override
  RxString dueDateText;
  @override
  RxBool highPriority;

  @override
  RxList responsibles;
  // to track changes
  List _previusSelectedResponsibles = [];

  Status initialStatus;
  Rx<Status> newStatus;

  final _userController = Get.find<UserController>();
  final _usersDataSource = Get.find<UsersDataSource>();
  PortalUserItemController selfUserItem;

  @override
  TextEditingController get titleController => _titleController;

  void initTaskEditing() {
    title = task.title.obs;
    _titleController.text = task.title;
    _taskItemController = Get.find<TaskItemController>(tag: task.id.toString());
    initialStatus = _taskItemController.status.value;
    newStatus = initialStatus.obs;
    descriptionText = task.description.obs;
    descriptionController.value.text = task.description;
    selectedMilestoneTitle = task.milestone?.title?.obs ?? 'None'.obs;
    _newMilestoneId = task.milestoneId;
    _newStartDate =
        task.startDate != null ? DateTime.parse(task.startDate) : null;
    startDateText = task.startDate?.obs ?? ''.obs;
    _newDueDate = task.deadline != null ? DateTime.parse(task.deadline) : null;
    dueDateText = task.deadline?.obs ?? ''.obs;
    highPriority = task.priority == 1 ? true.obs : false.obs;
    responsibles = [].obs;
    for (var user in task.responsibles) {
      responsibles.add(PortalUserItemController(portalUser: user));
    }
  }

  @override
  void changeTitle(String newText) {
    // if (newText.isNotEmpty) setTitleError.value = false;
    title.value = newText;
  }

  void changeStatus(Status status) => newStatus.value = status;

  @override
  void confirmDescription(String newText) {
    descriptionController.value.text = newText;
    descriptionText.value = newText;
    Get.back();
  }

  @override
  void leaveDescriptionView(String typedText) {
    if (typedText == descriptionText.value) {
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: 'Discard changes?',
        contentText: 'If you leave, all changes will be lost.',
        acceptText: 'DELETE',
        onAcceptTap: () {
          descriptionController.value.text = task.description;
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  @override
  void changeMilestoneSelection({var id, String title}) {
    if (id != null && title != null) {
      selectedMilestoneTitle.value = title;
      _newMilestoneId = id;
    } else {
      removeMilestoneSelection();
    }
    Get.back();
  }

  void removeMilestoneSelection() {
    _newMilestoneId = null;
    selectedMilestoneTitle.value = 'None';
  }

  @override
  void changeStartDate(DateTime newDate) {
    if (newDate != null) {
      startDateText.value = formatedDate(newDate);
      _newStartDate = newDate;
      Get.back();
    } else {
      startDateText.value = '';
      _newDueDate = null;
    }
  }

  @override
  void changeDueDate(DateTime newDate) {
    if (newDate != null) {
      _newDueDate = newDate;
      dueDateText.value = formatedDate(newDate);
      Get.back();
    } else {
      dueDateText.value = '';
      _newDueDate = null;
    }
  }

  @override
  void changePriority(bool value) => highPriority.value = value;

  void confirmResponsiblesSelection() {
    // ignore: invalid_use_of_protected_member
    _previusSelectedResponsibles = List.of(responsibles.value);
    Get.back();
  }

  void leaveResponsiblesSelectionView() {
    // ignore: invalid_use_of_protected_member
    if (listEquals(_previusSelectedResponsibles, responsibles.value)) {
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: 'Discard changes?',
        contentText: 'If you leave, all changes will be lost.',
        acceptText: 'DELETE',
        onAcceptTap: () {
          responsibles.value = List.of(_previusSelectedResponsibles);
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  void setupResponsiblesSelection() async {
    await _userController.getUserInfo();
    var selfUser = _userController.user;
    selfUserItem = PortalUserItemController(portalUser: selfUser);
    selfUserItem.multipleSelectionEnabled.value = true;
    _usersDataSource.applyUsersSelection = _getSelectedResponsibles;
    await _usersDataSource.getProfiles(needToClear: true);
  }

  Future<void> _getSelectedResponsibles() async {
    for (var element in _usersDataSource.usersList) {
      element.isSelected.value = false;
      element.multipleSelectionEnabled.value = true;
    }
    for (var selectedMember in responsibles) {
      for (var user in _usersDataSource.usersList) {
        if (selectedMember.portalUser.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      }
      if (selfUserItem.portalUser.id == selectedMember.portalUser.id) {
        selfUserItem.isSelected.value = selectedMember.isSelected.value;
      }
    }
  }

  void addResponsible(PortalUserItemController user) {
    if (user.isSelected.isTrue) {
      responsibles.add(user);
    } else {
      responsibles.removeWhere(
          (element) => user.portalUser.id == element.portalUser.id);
    }
    if (selfUserItem.portalUser.id == user.portalUser.id) {
      selfUserItem.isSelected.value = user.isSelected.value;
    }
  }

  void discardChanges() {
    bool taskEdited;
    // checking all fields for changes
    taskEdited = title.value != task.title ||
        descriptionText.value != task.description ||
        _newMilestoneId != task.milestoneId ||
        initialStatus.id != newStatus.value.id ||
        task.responsibles.length != responsibles.length;

    var i = 0;
    while (!taskEdited && responsibles.length > i) {
      if (responsibles[i].portalUser.id != task.responsibles[i].id) {
        taskEdited = true;
      }
      i++;
    }

    // warn the user if there have been changes
    if (taskEdited) {
      Get.dialog(StyledAlertDialog(
        titleText: 'Discard changes?',
        contentText: 'Your changes will not be saved.',
        acceptText: 'DISCARD',
        onAcceptTap: () {
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    } else {
      //leave
      Get.back();
    }
  }

  void confirm() async {
    if (title.isEmpty || task.title == null) {
      setTitleError.value = true;
    } else {
      // update the task status if it has been changed
      if (initialStatus.id != newStatus.value.id) {
        await _taskItemController.updateTaskStatus(
            id: task.id,
            newStatusId: newStatus.value.id,
            newStatusType: newStatus.value.statusType);
      }
      // ignore: omit_local_variable_types
      List<String> responsibleIds = [];

      for (var item in responsibles) responsibleIds.add(item.id);

      var newTask = NewTaskDTO(
        description: descriptionText.value,
        deadline: _newDueDate,
        id: task.id,
        startDate: _newStartDate,
        priority: highPriority.isTrue ? 'High' : 'Normal',
        title: title.value,
        milestoneid: _newMilestoneId,
        projectId: task.projectOwner.id,
        responsibles: responsibleIds,
      );

      var updatedTask = await _api.updateTask(newTask: newTask);

      if (updatedTask != null) {
        // ignore: unawaited_futures
        _taskItemController.reloadTask();
        Get.back();
      }
    }
  }
}
