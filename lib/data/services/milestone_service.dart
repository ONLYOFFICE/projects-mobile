import 'package:projects/data/api/milestone_api.dart';
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/data/models/new_milestone_DTO.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class MilestoneService {
  final MilestoneApi _api = locator<MilestoneApi>();

  Future<List<Milestone>> milestonesByFilter(
      {int startIndex,
      String sortBy,
      String sortOrder,
      String projectId,
      String milestoneResponsibleFilter,
      String taskResponsibleFilter,
      String statusFilter,
      String deadlineFilter}) async {
    var milestones = await _api.milestonesByFilter(
      startIndex: startIndex,
      sortBy: sortBy,
      sortOrder: sortOrder,
      projectId: projectId,
      milestoneResponsibleFilter: milestoneResponsibleFilter,
      taskResponsibleFilter: taskResponsibleFilter,
      statusFilter: statusFilter,
      deadlineFilter: deadlineFilter,
    );

    var success = milestones.response != null;

    if (success) {
      return milestones.response;
    } else {
      ErrorDialog.show(milestones.error);
      return null;
    }
  }

  Future<bool> createMilestone(
      {int projectId, NewMilestoneDTO milestone}) async {
    var result = await _api.createMilestone(
      projectId: projectId,
      milestone: milestone,
    );

    var success = result.response != null;

    if (success) {
      return success;
    } else {
      ErrorDialog.show(result.error);
      return false;
    }
  }
}
