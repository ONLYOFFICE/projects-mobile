import 'package:get/get.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/item.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectsController extends GetxController {
  final _api = locator<ProjectService>();

  List<Status> statuses;

  var startIndex = 0;

  @override
  void onInit() {
    super.onInit();
  }

  var projects = [].obs;

  RefreshController refreshController = RefreshController(initialRefresh: true);

  void onRefresh() async {
    startIndex = 0;
    await getProjects(needToClear: true);
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    startIndex++;
    await getProjects();
    refreshController.loadComplete();
  }

  Future getProjects({needToClear = false}) async {
    var items = await _api.getProjectsByParams(startIndex: startIndex);
    if (needToClear) projects.clear();

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
