import 'package:get/get.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/item.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectsController extends BaseController {
  final _api = locator<ProjectService>();

  var loaded = false.obs;
  List<Status> statuses;

  var startIndex = 0;

  int totalProjects = 0;

  bool get pullUpEnabled => projects.length != totalProjects;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  String get screenName => 'Projects';

  @override
  RxList get itemList => projects;

  RxList projects = [].obs;

  RefreshController refreshController = RefreshController();

  @override
  void showSearch() {
    Get.toNamed('ProjectSearchView');
  }

  void onRefresh() async {
    startIndex = 0;
    await _getProjects(needToClear: true);
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    startIndex += 25;
    if (startIndex >= totalProjects) {
      refreshController.loadComplete();
      startIndex -= 25;
      return;
    }
    await _getProjects();
    refreshController.loadComplete();
  }

  Future<void> setupProjects() async {
    loaded.value = false;
    startIndex = 0;
    await _getProjects(needToClear: true);
    loaded.value = true;
  }

  Future _getProjects({needToClear = false}) async {
    var result = await _api.getProjectsByParams(startIndex: startIndex);
    totalProjects = result.total;

    if (needToClear) projects.clear();

    result.response.forEach(
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
