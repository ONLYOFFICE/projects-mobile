import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/project_status.dart';

import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectTeamController extends GetxController {
  final _api = locator<ProjectService>();
  var usersList = <PortalUserItemController>[].obs;
  var loaded = true.obs;
  var nothingFound = false.obs;
  var _startIndex = 0;
  RefreshController refreshController = RefreshController();
  var totalProfiles;
  var _projectId;
  var isSearchResult = false.obs;
  var searchResult = <PortalUserItemController>[].obs;
  UserSelectionMode selectionMode = UserSelectionMode.None;

  bool _withoutVisitors = false;
  var fabIsVisible = false.obs;

  ProjectDetailed _projectDetailed;

  bool get pullUpEnabled => usersList.length != totalProfiles;

  Future onLoading() async {
    _startIndex += 25;
    if (_startIndex >= totalProfiles) {
      refreshController.loadComplete();
      _startIndex -= 25;
      return;
    }
    await _loadTeam();
    refreshController.loadComplete();
  }

  Future _loadTeam({bool needToClear = false}) async {
    var result = await _api.getProjectTeam(_projectId.toString());

    totalProfiles = result.length;

    if (needToClear) usersList.clear();

    for (var element in result) {
      if (_withoutVisitors && element.isVisitor) continue;

      var portalUser = PortalUserItemController(portalUser: element);
      portalUser.selectionMode.value = selectionMode;
      usersList.add(portalUser);
    }

    nothingFound.value = usersList.isEmpty;
  }

  Future getTeam({bool needToClear = true}) async {
    loaded.value = false;
    await _loadTeam(needToClear: needToClear);

    if (_projectDetailed?.status == ProjectStatusCode.closed.index) {
      fabIsVisible.value = false;

      loaded.value = true;
      return;
    }

    var _userController = Get.find<UserController>();
    await _userController.getUserInfo();
    var selfUser = _userController.user;

    for (var element in usersList) {
      if (element.id == selfUser.id) {
        fabIsVisible.value = true;
        break;
      }
    }

    if (_projectDetailed != null && _projectDetailed.security['canEditTeam']) {
      fabIsVisible.value = true;
    } else {
      if (selfUser.isAdmin ||
          selfUser.isOwner ||
          (selfUser.listAdminModules != null &&
              selfUser.listAdminModules.contains('projects'))) {
        fabIsVisible.value = true;
      }
    }

    if (selfUser.isVisitor) fabIsVisible.value = false;

    loaded.value = true;
  }

  void searchUsers(query) {
    searchResult.clear();
    if (query == '') {
      nothingFound.value = usersList.isEmpty;
      isSearchResult.value = false;
    }
    isSearchResult.value = true;
    searchResult.addAll(usersList.where((user) =>
        user.displayName.toLowerCase().contains(query.toLowerCase())));

    nothingFound.value = searchResult.isEmpty;
  }

  void setup(
      {ProjectDetailed projectDetailed,
      bool withoutVisitors = false,
      projectId}) {
    _withoutVisitors = withoutVisitors;
    _projectId = projectId ?? projectDetailed.id;
    _projectDetailed = projectDetailed;
  }
}
