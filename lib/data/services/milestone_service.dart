import 'package:projects/data/api/milestone_api.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class MilestoneService {
  final MilestoneApi _api = locator<MilestoneApi>();

  Future milestonesByFilter() async {
    var milestones = await _api.milestonesByFilter();

    var success = milestones.response != null;

    if (success) {
      return milestones.response;
    } else {
      ErrorDialog.show(milestones.error);
      return null;
    }
  }
}
