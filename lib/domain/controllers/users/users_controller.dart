import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/user_service.dart';

class UsersController extends GetxController {
  final _api = locator<UserService>();

  var users = <PortalUser>[].obs;

  RxBool loaded = false.obs;

  Future getAllProfiles({String params}) async {
    loaded.value = false;
    users.value = await _api.getAllProfiles();
    loaded.value = true;
  }
}
