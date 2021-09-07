import 'package:projects/data/api/discussions_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/models/from_api/new_discussion_DTO.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class DiscussionsService {
  final DiscussionsApi _api = locator<DiscussionsApi>();
  final SecureStorage _secureStorage = locator<SecureStorage>();

  Future<PageDTO<List<Discussion>>> getDiscussionsByParams({
    int startIndex,
    String query,
    String sortBy,
    String sortOrder,
    String authorFilter,
    String statusFilter,
    String projectFilter,
    String projectId,
    String creationDateFilter,
    String otherFilter,
  }) async {
    var projects = await _api.getDiscussionsByParams(
      startIndex: startIndex,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
      authorFilter: authorFilter,
      statusFilter: statusFilter,
      creationDateFilter: creationDateFilter,
      projectFilter: projectFilter,
      otherFilter: otherFilter,
      projectId: projectId,
    );

    var success = projects.response != null;

    if (success) {
      return projects;
    } else {
      await ErrorDialog.show(projects.error);
      return null;
    }
  }

  Future<Discussion> addMessage({
    int projectId,
    NewDiscussionDTO newDiscussion,
  }) async {
    var result =
        await _api.addMessage(projectId: projectId, newDiss: newDiscussion);

    var success = result.response != null;

    if (success) {
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.createEntity, {
        AnalyticsService.Params.Key.portal : await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity : AnalyticsService.Params.Value.discussion
      });
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }
}
