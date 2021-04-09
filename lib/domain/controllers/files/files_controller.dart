import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/internal/locator.dart';

class FilesController extends GetxController {
  final _api = locator<FilesService>();

  var files = <PortalFile>[].obs;

  RxBool loaded = false.obs;

  Future getTaskFiles({int taskId}) async {
    loaded.value = false;
    files.value = await _api.getTaskFiles(taskId: taskId);
    loaded.value = true;
  }
}
