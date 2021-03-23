import 'package:get/get.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/item.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectsController extends GetxController {
  final _api = locator<ProjectService>();

  List<Status> statuses;

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
    var items = await _api.getProjectsByParams();
    projects.clear();

    items.forEach(
      (element) {
        projects.add(Item(
          id: element.id,
          title: element.title,
          status: element.status,
          responsible: element.responsible,
          date: element.creationDate(),
          subCount: element.taskCount,
          isImportant: false,
        ));
      },
    );
  }
}
