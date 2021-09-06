import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/user_service.dart';

class UsersController extends BaseController {
  final _api = locator<UserService>();

  PaginationController paginationController;

  @override
  void onInit() {
    screenName = tr('users');
    paginationController =
        Get.put(PaginationController(), tag: 'UsersController');

    paginationController.loadDelegate = () async => await _getUsers();
    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;

    super.onInit();
  }

  @override
  var itemList = [].obs;

  RxBool loaded = false.obs;

  Future<void> refreshData() async {
    loaded.value = false;
    await _getUsers(needToClear: true);
    loaded.value = true;
  }

  Future getAllProfiles({String params}) async {
    loaded.value = false;
    itemList.value = await _api.getAllProfiles();
    loaded.value = true;
  }

  Future getUsers({bool needToClear = false}) async {
    paginationController.startIndex = 0;
    loaded.value = false;
    await _getUsers(needToClear: needToClear);
    loaded.value = true;
  }

  Future _getUsers({bool needToClear = false}) async {
    var result = await _api.getProfilesByExtendedFilter(
      startIndex: paginationController.startIndex,
    );

    if (result != null) {
      paginationController.total.value = result.total;
      if (needToClear) paginationController.data.clear();
      paginationController.data.addAll(result.response);
    }
  }
}
