import 'package:get/get.dart';
import 'package:projects/data/models/project_status.dart';

class ProjectStatusesController extends GetxController {
  RxList statuses = <int>[0, 1, 2].obs;
  RxList statusImagesDecoded = <String>[].obs;
  RxBool loaded = false.obs;

  String getStatusName(int value) => ProjectStatus.toName(value);
  String getStatusImageString(int value) => ProjectStatus.toImageString(value);
}
