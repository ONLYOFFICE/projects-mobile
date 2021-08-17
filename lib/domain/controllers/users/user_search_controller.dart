import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/base/base_search_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';

class UserSearchController extends BaseSearchController {
  final _api = locator<UserService>();

  final PaginationController _paginationController = PaginationController();
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
    var result = await _api.getProfilesByExtendedFilter(
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
