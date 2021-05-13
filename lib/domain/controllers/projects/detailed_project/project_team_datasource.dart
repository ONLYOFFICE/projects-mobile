import 'package:get/get.dart';

import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectTeamDataSource extends GetxController {
  final _api = locator<ProjectService>();
  var usersList = [].obs;
  var loaded = true.obs;

  var _startIndex = 0;

  RefreshController refreshController = RefreshController();

  var totalProfiles;

  ProjectDetailed projectDetailed;

  bool get pullUpEnabled => usersList.length != totalProfiles;

  void onLoading() async {
    _startIndex += 25;
    if (_startIndex >= totalProfiles) {
      refreshController.loadComplete();
      _startIndex -= 25;
      return;
    }
    _loadTeam();
    refreshController.loadComplete();
  }

  void _loadTeam({bool needToClear = false}) async {
    var result = await _api.getProjectTeam(projectDetailed.id.toString());

    totalProfiles = result.length;

    if (needToClear) usersList.clear();

    for (var element in result) {
      var portalUser = PortalUserItemController(portalUser: element);
      portalUser.multipleSelectionEnabled.value = false;
      usersList.add(portalUser);
    }
  }

  Future getTeam() async {
    loaded.value = false;
    _loadTeam(needToClear: true);
    loaded.value = true;
  }
}