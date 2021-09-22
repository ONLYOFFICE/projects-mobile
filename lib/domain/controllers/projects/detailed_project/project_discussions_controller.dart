import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/models/from_api/security_info.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/discussions/discussions_sort_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/new_discussion/new_discussion_screen.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_detailed.dart';

class ProjectDiscussionsController extends GetxController {
  final _api = locator<DiscussionsService>();
  final projectId;
  var projectTitle;

  final _paginationController =
      Get.put(PaginationController(), tag: 'ProjectDiscussionsController');

  PaginationController get paginationController => _paginationController;

  final _sortController = Get.find<DiscussionsSortController>();

  RxBool loaded = false.obs;

  final _userController = Get.find<UserController>();
  SecrityInfo _securityInfo;
  var fabIsVisible = false.obs;
  String _selfId;
  final _projectService = locator<ProjectService>();

  ProjectDiscussionsController(this.projectId, this.projectTitle) {
    _sortController.updateSortDelegate =
        () async => await loadProjectDiscussions();

    paginationController.loadDelegate = () async => await _getDiscussions();
    paginationController.refreshDelegate =
        () async => await _getDiscussions(needToClear: true);
    paginationController.pullDownEnabled = true;

    var team;

    _userController.getUserInfo().then((value) async => {
          _selfId ??= await _userController.getUserId(),
          _securityInfo ??= await _projectService.getProjectSecurityinfo(),
          team = await _projectService.getProjectTeam(projectId.toString()),
          if (team.any((element) => element.id == _selfId))
            fabIsVisible.value = canCreate
          else
            fabIsVisible.value = false
        });
  }

  bool get canCreate =>
      _userController.user.isAdmin ||
      _userController.user.isOwner ||
      _securityInfo.canCreateMessage;

  RxList get itemList => paginationController.data;

  Future loadProjectDiscussions() async {
    loaded.value = false;
    paginationController.startIndex = 0;
    await _getDiscussions(needToClear: true);
    loaded.value = true;
  }

  Future _getDiscussions({needToClear = false}) async {
    var result = await _api.getDiscussionsByParams(
      startIndex: paginationController.startIndex,
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectId: projectId.toString(),
    );
    paginationController.total.value = result.total;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response);
  }

  void toDetailed(Discussion discussion) => Get.find<NavigationController>()
      .to(DiscussionDetailed(), arguments: {'discussion': discussion});

  void toNewDiscussionScreen() =>
      Get.find<NavigationController>().to(const NewDiscussionScreen(),
          arguments: {'projectId': projectId, 'projectTitle': projectTitle});
}
