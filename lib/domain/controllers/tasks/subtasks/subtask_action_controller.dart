import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';

abstract class SubtaskActionController extends GetxController {
  final TextEditingController _titleController = TextEditingController();
  TextEditingController get titleController => _titleController;
  FocusNode get titleFocus;
  RxBool setTiltleError;
  RxInt status;

  void init({Subtask subtask});
  void addResponsible(PortalUserItemController user);
  Future<void> confirm({@required context, int taskId});
  void confirmResponsiblesSelection();
  void leaveResponsiblesSelectionView();
  void deleteResponsible();
  void leavePage();
}
