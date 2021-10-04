import 'package:get/get.dart';
import 'package:projects/data/api/milestone_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/data/models/new_milestone_DTO.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class MilestoneService {
  final MilestoneApi _api = locator<MilestoneApi>();
  final SecureStorage _secureStorage = locator<SecureStorage>();

  Future<List<Milestone>> milestonesByFilter({
    int startIndex,
    String sortBy,
    String sortOrder,
    String projectId,
    String milestoneResponsibleFilter,
    String taskResponsibleFilter,
    String statusFilter,
    String deadlineFilter,
    String query,
  }) async {
    var milestones = await _api.milestonesByFilter(
      startIndex: startIndex,
      sortBy: sortBy,
      sortOrder: sortOrder,
      projectId: projectId,
      milestoneResponsibleFilter: milestoneResponsibleFilter,
      taskResponsibleFilter: taskResponsibleFilter,
      statusFilter: statusFilter,
      deadlineFilter: deadlineFilter,
      query: query,
    );

    var success = milestones.response != null;

    if (success) {
      return milestones.response;
    } else {
      await Get.find<ErrorDialog>().show(milestones.error.message);
      return null;
    }
  }

  Future<PageDTO<List<Milestone>>> milestonesByFilterPaginated({
    int startIndex,
    String sortBy,
    String sortOrder,
    String projectId,
    String milestoneResponsibleFilter,
    String taskResponsibleFilter,
    String statusFilter,
    String deadlineFilter,
    String query,
  }) async {
    var milestones = await _api.milestonesByFilterPaginated(
      startIndex: startIndex,
      sortBy: sortBy,
      sortOrder: sortOrder,
      projectId: projectId,
      milestoneResponsibleFilter: milestoneResponsibleFilter,
      taskResponsibleFilter: taskResponsibleFilter,
      statusFilter: statusFilter,
      deadlineFilter: deadlineFilter,
      query: query,
    );

    var success = milestones.response != null;

    if (success) {
      return milestones;
    } else {
      await Get.find<ErrorDialog>().show(milestones.error.message);
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
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.createEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.milestone
      });
      return success;
    } else {
      await Get.find<ErrorDialog>().show(result.error.message);
      return false;
    }
  }
}
