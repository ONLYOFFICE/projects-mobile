import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class TaskActionsController extends GetxController {
  RxString title;
  RxString descriptionText;
  RxString selectedMilestoneTitle;
  var selectedProjectTitle;
  RxList responsibles;
  RxString startDateText;
  RxString dueDateText;

  RxBool highPriority;

  TextEditingController _titleController;
  TextEditingController get titleController => _titleController;

  RxBool setTitleError;
  var selectProjectError;

  void changeMilestoneSelection();
  void leaveDescriptionView(String typedText);

  void confirmDescription(String typedText);
  void changeTitle(String newText);
  void changeStartDate(DateTime newDate);
  void changeDueDate(DateTime newDate);
  void changePriority(bool value);
}
