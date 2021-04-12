import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FilesController extends GetxController {
  final _api = locator<FilesService>();

  var files = <PortalFile>[].obs;

  var refreshController = RefreshController(initialRefresh: false);

//for shimmer and progress indicator
  RxBool loaded = false.obs;

  void onRefresh({@required int taskId}) async {
    await getTaskFiles(taskId: taskId);
    refreshController.refreshCompleted();
  }

  Future getTaskFiles({int taskId}) async {
    loaded.value = false;
    files.value = await _api.getTaskFiles(taskId: taskId);
    loaded.value = true;
  }
}
