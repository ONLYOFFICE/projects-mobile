import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';

class NewTaskController extends GetxController {
  var _selectedProjectId;
  var _selectedMilestoneId;
  // for dateTime format
  String _startDate = '';
  String _dueDate = '';

  int get selectedProjectId => _selectedProjectId;
  int get selectedMilestoneId => _selectedMilestoneId;
  String get startDate => _startDate;
  String get dueDate => _dueDate;

  RxString title = ''.obs;
  RxString slectedProjectTitle = ''.obs;
  RxString slectedMilestoneTitle = ''.obs;

  RxString descriptionText = ''.obs;
  var descriptionController = TextEditingController().obs;
  // for readable format
  RxString startDateText = ''.obs;
  RxString dueDateText = ''.obs;
  RxBool highPriority = false.obs;

  RxBool selectProjectError = false.obs;

  void changeTitle(String newText) => title.value = newText;

  void changeProjectSelection({var id, String title}) {
    if (id != null && title != null) {
      slectedProjectTitle.value = title;
      _selectedProjectId = id;
      selectProjectError.value = false;
    } else {
      removeProjectSelection();
    }
    Get.back();
  }

  void removeProjectSelection() {
    _selectedProjectId = null;
    slectedProjectTitle.value = '';
  }

  void changeMilestoneSelection({var id, String title}) {
    if (id != null && title != null) {
      slectedMilestoneTitle.value = title;
      _selectedMilestoneId = id;
    } else {
      removeMilestoneSelection();
    }
    Get.back();
  }

  void removeMilestoneSelection() {
    _selectedMilestoneId = null;
    slectedMilestoneTitle.value = '';
  }

  void changePriority(bool value) {
    highPriority.value = value;
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
        titleText: 'Discard changes?',
        contentText: 'If you leave, all changes will be lost.',
        acceptText: 'DELETE',
        onAcceptTap: () {
          descriptionController.value.text = descriptionText.value;
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  void changeStartDate(String newDate) {
    if (newDate != null) {
      _startDate = newDate;
      startDateText.value =
          formatedDate(now: DateTime.now(), stringDate: newDate);
      Get.back();
    }
  }

  void changeDueDate(String newDate) {
    if (newDate != null) {
      _dueDate = newDate;
      dueDateText.value =
          formatedDate(now: DateTime.now(), stringDate: newDate);
      Get.back();
    }
  }

  void confirm() {
    print(_selectedProjectId);
    if (_selectedProjectId == null) selectProjectError.value = true;
  }
}
