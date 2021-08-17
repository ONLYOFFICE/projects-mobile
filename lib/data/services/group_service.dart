import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_group.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/group_api.dart';

class GroupService {
  final GroupApi _api = locator<GroupApi>();

  Future getAllGroups() async {
    var groups = await _api.getAllGroups();

    var success = groups.response != null;

    if (success) {
      return groups.response;
    } else {
      await ErrorDialog.show(groups.error);
      return null;
    }
  }

  Future<PageDTO<List<PortalGroup>>> getGroupsByExtendedFilter({
    int startIndex,
    String query,
    String groupId,
  }) async {
    var profiles = await _api.getProfilesByExtendedFilter(
      startIndex: startIndex,
      query: query,
    );

    var success = profiles.response != null;

    if (success) {
      return profiles;
    } else {
      await ErrorDialog.show(profiles.error);
      return null;
    }
  }
}
