import 'package:get/get.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';

class NewTaskController extends GetxController {
  var _selectedProjectId;
  var _selectedMilestoneId;
  String _description;
  String _startDate = '';
  String _dueDate = '';

  int get selectedProjectId => _selectedProjectId;
  int get selectedMilestoneId => _selectedMilestoneId;
  String get description => _description;
  String get startDate => _startDate;
  String get dueDate => _dueDate;

  RxString titleText = ''.obs;

  RxString projectTileText = 'Select project'.obs;

  RxString milestoneTileText = 'Select milestone'.obs;

  RxString descriptionText = 'Add description'.obs;
  RxBool highPriority = false.obs;

  RxString startDateText = 'Set start date'.obs;
  RxString dueDateText = 'Set due date'.obs;

  RxBool selectProjectError = false.obs;

  void changeTitle(String newText) => titleText.value = newText;

  void changeProjectSelection({var id, String title}) {
    if (id != null && title != null) {
      projectTileText.value = title;
      _selectedProjectId = id;
      selectProjectError.value = false;
    } else {
      removeProjectSelection();
    }
    Get.back();
  }

  void removeProjectSelection() {
    _selectedProjectId = null;
    projectTileText.value = 'Select project';
  }

  void changeMilestoneSelection({var id, String title}) {
    if (id != null && title != null) {
      milestoneTileText.value = title;
      _selectedMilestoneId = id;
    } else {
      removeMilestoneSelection();
    }
    Get.back();
  }

  void removeMilestoneSelection() {
    _selectedMilestoneId = null;
    milestoneTileText.value = 'Select milestone';
  }

  void changePriority(bool value) {
    highPriority.value = value;
  }

  void confirmDescription(String newText) {
    descriptionText.value = newText;
    _description = newText;
    Get.back();
  }

  void leaveDescriptionView(String typedText) {
    if (typedText.isEmpty) {
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: 'Discard changes?',
        contentText: 'If you leave, all changes will be lost.',
        acceptText: 'DELETE',
        onAcceptTap: () {
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
