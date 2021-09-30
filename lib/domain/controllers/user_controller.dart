import 'package:projects/data/models/from_api/security_info.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:synchronized/synchronized.dart';

import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/internal/locator.dart';

class UserController extends GetxController {
  final _api = locator<AuthService>();
  PortalUser user;
  var lock = Lock();

  SecrityInfo securityInfo;

  Future getUserInfo() async {
    await lock.synchronized(() async {
      if (user != null && user.id != null) {
        return;
      }

      var data = await _api.getSelfInfo();
      user = data.response;

      securityInfo ??= await locator<ProjectService>().getProjectSecurityinfo();
    });
  }

  Future<String> getUserId() async {
    if (user == null || user.id == null) {
      await getUserInfo();
    }
    return user.id;
  }
}
