import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_tag.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/item.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/projects_view/project_sort.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectsController extends BaseController {
  final _api = locator<ProjectService>();

  var loaded = false.obs;
  List<Status> statuses;
  RxList<ProjectTag> tags = <ProjectTag>[].obs;

  var _startIndex = 0;

  int totalProjects = 0;

  var _sortBy;
  var _sortOrder;

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

  ProjectsSortController sortController;

  @override
  void showSearch() {
    Get.toNamed('ProjectSearchView');
  }

  @override
  void showSortView() {
    Get.bottomSheet(ProjectSort(), isScrollControlled: true);
  }

  void updateSort() {
    _getProjects(needToClear: true);
  }

  void onRefresh() async {
    _startIndex = 0;
    await _getProjects(needToClear: true);
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    _startIndex += 25;
    if (_startIndex >= totalProjects) {
      refreshController.loadComplete();
      _startIndex -= 25;
      return;
    }
    await _getProjects();
    refreshController.loadComplete();
  }

  Future<void> setupProjects() async {
    loaded.value = false;
    _startIndex = 0;
    await _getProjects(needToClear: true);
    loaded.value = true;
  }

  Future _getProjects({needToClear = false}) async {
    var result = await _api.getProjectsByParams(
        startIndex: _startIndex,
        sortBy: sortController.currentSortfilter,
        sortOrder: sortController.currentSortOrder);
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

  Future getProjectTags() async {
    loaded.value = false;
    tags.value = await _api.getProjectTags();
    loaded.value = true;
  }

  void createNewProject() {
    Get.toNamed('NewProject');
  }
}
