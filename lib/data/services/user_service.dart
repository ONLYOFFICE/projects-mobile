import 'package:get/get.dart';
import 'package:projects/data/api/user_api.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class UserService {
  final UserApi _api = locator<UserApi>();

  var portalTask = PortalTask().obs;

  Future getAllProfiles() async {
    var profiles = await _api.getAllProfiles();

    var success = profiles.response != null;

    if (success) {
      return profiles.response;
    } else {
      ErrorDialog.show(profiles.error);
      return null;
    }
  }
}
