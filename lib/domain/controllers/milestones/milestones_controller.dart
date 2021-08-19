import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/milestone_service.dart';

class MilestonesController extends GetxController {
  final MilestoneService _api = locator<MilestoneService>();

  PaginationController paginationController;

  @override
  void onInit() {
    paginationController =
        Get.put(PaginationController(), tag: 'MilestonesController');

    paginationController.loadDelegate = () async => await _getMilestones();
    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;
    super.onInit();
  }

  RxBool loaded = false.obs;

  var milestones = [].obs;

  Future getAllMilestones() async {
    loaded.value = false;
    milestones.value = await _api.milestonesByFilter();
    loaded.value = true;
  }

  Future getMilestones({bool needToClear = false}) async {
    paginationController.startIndex = 0;
    loaded.value = false;
    await _getMilestones();
    loaded.value = true;
  }

  Future _getMilestones({bool needToClear = false}) async {
    var result = await _api.milestonesByFilterPaginated(
      startIndex: paginationController.startIndex,
    );

    if (result != null) {
      paginationController.total.value = result.total;
      if (needToClear) paginationController.data.clear();
      paginationController.data.addAll(result.response);
    }
  }

  Future<void> refreshData() async {
    loaded.value = false;
    await _getMilestones(needToClear: true);
    loaded.value = true;
  }
}

// class MilestonesController extends GetxController {
//   final _api = locator<MilestoneService>();

//   var milestones = <Milestone>[].obs;

//   RxBool loaded = false.obs;

//   Future getMilestonesByFilter() async {
//     loaded.value = false;
//     milestones.value = await _api.milestonesByFilter();
//     loaded.value = true;
//   }
// }
