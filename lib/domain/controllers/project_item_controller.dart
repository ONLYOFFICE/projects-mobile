import 'dart:convert';

import 'package:get/get.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/item.dart';
import 'package:projects/domain/controllers/statuses_controller.dart';

class ProjectItemController extends GetxController {
  List<Status> statuses;

  ProjectItemController(Item project) {
    this.project = project;
    StatusesController statusesController = Get.find();

    statusesController.getStatuses().then((value) => {
          statuses = value,
          statusImageString =
              decodeImageString(statuses[project.status].image).obs,
        });
  }

  var project;

  var statusImageString = ''.obs;

  decodeImageString(String image) {
    return utf8.decode(
      base64.decode(statuses[project.status].image),
    );
  }
}
