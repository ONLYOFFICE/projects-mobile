import 'package:get/get.dart';
import 'package:only_office_mobile/data/models/from_api/portal_user.dart';
import 'package:only_office_mobile/data/models/from_api/self_user_profile.dart';
import 'package:only_office_mobile/data/services/authentication_service.dart';
import 'package:only_office_mobile/internal/locator.dart';

class UserController extends GetxController {
  var _api = locator<AuthService>();

  SelfUserProfile user;

  @override
  void onInit() {
    super.onInit();

    Future.wait([getUserInfo()]);
  }

  Future getUserInfo() async {
    var data = await _api.getSelfInfo();
    user = data.response;
  }

  Future<String> getUserId() async {
    if (user == null || user.id == null) {
      await getUserInfo();
    }
    return user.id;
  }
}
