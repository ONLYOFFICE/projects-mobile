import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:projects/data/services/group_service.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';
import 'package:projects/internal/locator.dart';

class GroupsDataSource extends GetxController {
  final _api = locator<GroupService>();
  var groupsList = [].obs;
  var loaded = true.obs;

  var multipleSelectionEnabled = false;
  RefreshController refreshController = RefreshController();

  void onLoading() async {
    refreshController.loadComplete();
    _loadGroups();
    refreshController.loadComplete();
  }

  void _loadGroups({bool needToClear = false}) async {
    if (needToClear) groupsList.clear();

    var result;

    result = await _api.getAllGroups();

    if (result.isEmpty) {
    } else {
      result.forEach(
        (element) {
          var portalUser = PortalGroupItemController(portalGroup: element);

          groupsList.add(portalUser);
        },
      );
    }
  }

  void _clear() {
    groupsList.clear();
  }

  Future getGroups({bool needToClear}) async {
    _clear();
    loaded.value = false;
    _loadGroups(needToClear: true);
    loaded.value = true;
  }
}
