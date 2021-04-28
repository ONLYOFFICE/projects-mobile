import 'package:projects/data/api/milestone_api.dart';
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class MilestoneService {
  final MilestoneApi _api = locator<MilestoneApi>();

  Future<List<Milestone>> milestonesByFilter({
    int startIndex,
    String sortBy,
    String sortOrder,
    String projectId,
    String milestoneResponsibleFilter,
    String taskResponsibleFilter,
    String statusFilter,
  }) async {
    var milestones = await _api.milestonesByFilter(
      startIndex: startIndex,
      sortBy: sortBy,
      sortOrder: sortOrder,
      projectId: projectId,
      milestoneResponsibleFilter: milestoneResponsibleFilter,
      taskResponsibleFilter: taskResponsibleFilter,
      statusFilter: statusFilter,
    );

    var success = milestones.response != null;

    if (success) {
      return milestones.response;
    } else {
      ErrorDialog.show(milestones.error);
      return null;
    }
  }
}
