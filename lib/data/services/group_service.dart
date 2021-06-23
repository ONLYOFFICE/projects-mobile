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
}
