import 'package:get/get.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/domain/controllers/base/base_search_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';

class MilestoneSearchController extends BaseSearchController {
  final _service = locator<MilestoneService>();

  final _paginationController =
      Get.put(PaginationController(), tag: 'MilestoneSearchController');

  @override
  PaginationController get paginationController => _paginationController;

  String _query;

  @override
  void onInit() {
    paginationController.startIndex = 0;

    paginationController.loadDelegate =
        () async => await _performSearch(query: _query, needToClear: false);

    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;
    super.onInit();
  }

  @override
  Future search({needToClear = true, String query}) async {
    paginationController.startIndex = 0;
    loaded.value = false;
    _query = query;
    await _performSearch(query: query, needToClear: needToClear);
    loaded.value = true;
  }

  @override
  Future<void> refreshData() async {
    loaded.value = false;
    await _performSearch(needToClear: true, query: _query);
    loaded.value = true;
  }

  Future _performSearch({needToClear = true, String query}) async {
    var result = await _service.milestonesByFilterPaginated(
      startIndex: paginationController.startIndex,
      query: query,
    );

    addData(result, needToClear);
  }

  void clear() {
    paginationController.data.clear();
    _query = null;
  }
}
