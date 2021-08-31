import 'package:get/get.dart';

import 'package:projects/domain/controllers/projects/detailed_project/project_team_datasource.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';

class MilestoneTeamController extends ProjectTeamDataSource {
  var isSearchResult = false.obs;

  var searchResult = <PortalUserItemController>[].obs;

  void searchUsers(query) {
    searchResult.clear();
    if (query == '') {
      nothingFound.value = usersList.isEmpty;
      isSearchResult.value = false;
    }
    isSearchResult.value = true;
    searchResult
        .addAll(usersList.where((user) => user.displayName.contains(query)));

    nothingFound.value = searchResult.isEmpty;
  }
}
