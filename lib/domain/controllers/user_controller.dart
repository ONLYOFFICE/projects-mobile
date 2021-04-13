import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/self_user_profile.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/internal/locator.dart';

class UserController extends GetxController {
  final _api = locator<AuthService>();

  PortalUser user;
  RxBool loaded = false.obs;

  Future getUserInfo() async {
    loaded.value = false;
    var data = await _api.getSelfInfo();
    user = data.response;
    loaded.value = true;
  }

  Future<String> getUserId() async {
    if (user == null || user.id == null) {
      await getUserInfo();
    }
    return user.id;
  }
}
