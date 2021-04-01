import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NewTaskController extends GetxController {
  RxBool projectSelected = false.obs;

  var projectFieldC = TextEditingController();
  var descriptionFieldC = TextEditingController();
  var startDateFieldC = TextEditingController();
  var dueDateFieldC = TextEditingController();
}
