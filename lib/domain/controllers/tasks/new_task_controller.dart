import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';

class NewTaskController extends GetxController {
  var _selectedProjectId;
  RxString selectedProjectTitle = ''.obs;

  var _selectedMilestoneId;
  RxString selectedMilestoneTitle = ''.obs;

  RxString description = ''.obs;
  RxBool highPriority = false.obs;

  RxBool selectProjectError = false.obs;

  int get selectedProjectId => _selectedProjectId;
  int get selectedMilestoneId => _selectedMilestoneId;

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

  void changeMilestoneSelection({var id, String title}) {
    if (id != null && title != null) {
      selectedMilestoneTitle.value = title;
      _selectedMilestoneId = id;
    } else {
      removeMilestoneSelection();
    }
    Get.back();
  }

  void removeMilestoneSelection() {
    _selectedMilestoneId = null;
    selectedMilestoneTitle.value = '';
  }

  void changePriority(bool value) {
    highPriority.value = value;
  }

  void confirmDescription(String newText) {
    description.value = newText;
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
        onCancelTap: () => Get.back(),
      ));
    }
  }

  void confirm() {
    print(_selectedProjectId);
    if (_selectedProjectId == null) selectProjectError.value = true;
  }
}
