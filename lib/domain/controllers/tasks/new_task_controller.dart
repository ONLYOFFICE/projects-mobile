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
