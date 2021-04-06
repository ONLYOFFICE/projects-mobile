import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_group.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/group_service.dart';

class GroupsController extends GetxController {
  final _api = locator<GroupService>();

  RxList<PortalGroup> groups = <PortalGroup>[].obs;

//for shimmer and progress indicator
  RxBool loaded = false.obs;

  Future getAllGroups() async {
    loaded.value = false;
    groups.value = await _api.getAllGroups();
    loaded.value = true;
  }
}
