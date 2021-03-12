import 'package:get/get.dart';
import 'package:only_office_mobile/data/services/project_service.dart';
import 'package:only_office_mobile/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectsController extends GetxController {
  var _api = locator<ProjectService>();

  @override
  void onInit() {
    super.onInit();
  }

  var projects = [].obs;

  RefreshController refreshController = RefreshController(initialRefresh: true);

  void onRefresh() async {
    await getProjects();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    await getProjects();
    refreshController.loadComplete();
  }

  Future getProjects() async {
    var items = await _api.getFilteredProjects();
    projects.assignAll(items);
  }
}
