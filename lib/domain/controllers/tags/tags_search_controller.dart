import 'package:get/get.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base/base_search_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';

// currently not used. There is no way to search for groups using the api
class TagSearchController extends BaseSearchController {
  final _api = locator<ProjectService>();

  final PaginationController _paginationController =
      Get.put(PaginationController(), tag: 'TagSearchController');

  @override
  PaginationController get paginationController => _paginationController;

  @override
  void onInit() {
    paginationController.startIndex = 0;

    paginationController.loadDelegate =
        () async => await _performSearch(query: _query, needToClear: false);

    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;

    super.onInit();
  }

  String _query;

  @override
  Future search({needToClear = true, String query}) async {
    paginationController.startIndex = 0;
    loaded.value = false;
    _query = query;
    await _performSearch(needToClear: needToClear, query: query);
    loaded.value = true;
  }

  Future _performSearch({needToClear = true, String query}) async {
    // now the result is incorrect
    var result = await _api.getTagsPaginated(
      startIndex: paginationController.startIndex,
      query: query,
    );

    addData(result, needToClear);
  }

  @override
  Future<void> refreshData() async {
    loaded.value = false;
    await search(needToClear: true, query: _query);
    loaded.value = true;
  }
}
