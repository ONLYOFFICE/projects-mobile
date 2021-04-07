import 'package:get/get.dart';
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/services/milestone_service.dart';

class MilestonesController extends GetxController {
  final _api = locator<MilestoneService>();

  var milestones = <Milestone>[].obs;

  RxBool loaded = false.obs;

  Future getMilestonesByFilter() async {
    loaded.value = false;
    milestones.value = await _api.milestonesByFilter();
    loaded.value = true;
  }
}
