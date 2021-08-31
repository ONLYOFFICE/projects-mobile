import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';

class DiscussionSearchController extends BaseController {
  final _api = locator<DiscussionsService>();

  var loaded = true.obs;

  final PaginationController _paginationController = PaginationController();
  PaginationController get paginationController => _paginationController;

  @override
  String get screenName => tr('discussionsSearch');

  @override
  RxList get itemList => _paginationController.data;

  void init() => paginationController.startIndex = 0;

  Future searchDiscussions({needToClear = true, String query}) async {
    loaded.value = false;
    var result = await _api.getDiscussionsByParams(
      startIndex: paginationController.startIndex,
      query: query,
    );

    loaded.value = true;

    paginationController.total.value = result.total;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response);
  }
}
