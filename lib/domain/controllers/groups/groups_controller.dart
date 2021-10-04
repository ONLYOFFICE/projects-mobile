import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_group.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/group_service.dart';

class GroupsController extends BaseController {
  final _api = locator<GroupService>();

  @override
  RxList itemList = [].obs;

  PaginationController paginationController;

  @override
  void onInit() {
    screenName = tr('groups');
    paginationController =
        Get.put(PaginationController(), tag: 'GroupsController');

    paginationController.loadDelegate = () async => await _getGroups();
    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;
    super.onInit();
  }

  RxList<PortalGroup> groups = <PortalGroup>[].obs;

  RxBool loaded = false.obs;

  Future getAllGroups() async {
    loaded.value = false;
    groups.value = await _api.getAllGroups();
    loaded.value = true;
  }

  Future getGroups({bool needToClear = false}) async {
    paginationController.startIndex = 0;
    loaded.value = false;
    await _getGroups();
    loaded.value = true;
  }

  Future _getGroups({bool needToClear = false}) async {
    var result = await _api.getGroupsByExtendedFilter(
      startIndex: paginationController.startIndex,
    );

    if (result != null) {
      paginationController.total.value = result.total;
      if (needToClear) paginationController.data.clear();
      paginationController.data.addAll(result.response);
    }
  }

  Future<void> refreshData() async {
    loaded.value = false;
    await _getGroups(needToClear: true);
    loaded.value = true;
  }
}
