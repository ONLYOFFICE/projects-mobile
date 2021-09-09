import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';

import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
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
  var projectId;
  var isSearchResult = false.obs;
  var searchResult = <PortalUserItemController>[].obs;
  UserSelectionMode selectionMode = UserSelectionMode.None;

  bool withoutVisitors = false;

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
    var result = await _api.getProjectTeam(projectId.toString());

    totalProfiles = result.length;

    if (needToClear) usersList.clear();

    for (var element in result) {
      if (withoutVisitors && element.isVisitor) continue;

      var portalUser = PortalUserItemController(portalUser: element);
      portalUser.selectionMode.value = selectionMode;
      usersList.add(portalUser);
    }

    nothingFound.value = usersList.isEmpty;
  }

  Future getTeam({bool needToClear = true}) async {
    loaded.value = false;
    await _loadTeam(needToClear: needToClear);
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
}
