import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:get/get.dart';

import 'package:projects/data/models/from_api/project_tag.dart';
import 'package:projects/data/models/item.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/internal/locator.dart';

class ProjectsController extends BaseController {
  final _api = locator<ProjectService>();

  var loaded = false.obs;

  RxList<ProjectTag> tags = <ProjectTag>[].obs;

  var paginationController =
      Get.put(PaginationController(), tag: 'ProjectsController');

  @override
  String get screenName => 'Projects';

  @override
  RxList get itemList => paginationController.data;

  final _sortController = Get.find<ProjectsSortController>();

  ProjectsController() {
    _sortController.updateSortDelegate = updateSort;
    paginationController.loadDelegate = () async {
      await _getProjects();
    };
    {
      paginationController.refreshDelegate = () async {
        await _getProjects(needToClear: true);
      };
    }
    paginationController.pullDownEnabled = true;
  }

  @override
  void showSearch() {
    Get.toNamed('ProjectSearchView');
  }

  void updateSort() {
    _getProjects(needToClear: true);
  }

  Future<void> setupProjects() async {
    loaded.value = false;
    paginationController.startIndex = 0;
    await _getProjects(needToClear: true);
    loaded.value = true;
  }

  Future _getProjects({needToClear = false}) async {
    var result = await _api.getProjectsByParams(
        startIndex: paginationController.startIndex,
        sortBy: _sortController.currentSortfilter,
        sortOrder: _sortController.currentSortOrder);
    paginationController.total = result.total;

    if (needToClear) paginationController.data.clear();

    result.response.forEach(
      (element) {
        paginationController.data.add(Item(
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
