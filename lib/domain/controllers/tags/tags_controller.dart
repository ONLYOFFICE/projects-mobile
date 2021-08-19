import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';

class TagsController extends BaseController {
  final _api = locator<ProjectService>();

  PaginationController paginationController;

  @override
  void onInit() {
    paginationController =
        Get.put(PaginationController(), tag: 'TagsController');

    paginationController.loadDelegate = () async => await _getItems();
    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;
    super.onInit();
  }

  @override
  var itemList = [].obs;

  @override
  String get screenName => tr('tags');

  RxBool loaded = false.obs;

  Future<void> refreshData() async {
    loaded.value = false;
    await _getItems(needToClear: true);
    loaded.value = true;
  }

  Future getItems({bool needToClear = false}) async {
    paginationController.startIndex = 0;
    loaded.value = false;
    await _getItems(needToClear: needToClear);
    loaded.value = true;
  }

  Future _getItems({bool needToClear = false}) async {
    var result = await _api.getTagsPaginated(
        startIndex: paginationController.startIndex);

    if (result != null) {
      paginationController.total.value = result.total;
      if (needToClear) paginationController.data.clear();
      paginationController.data.addAll(result.response);
    }
  }
}
