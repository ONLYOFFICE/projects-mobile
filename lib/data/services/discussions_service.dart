import 'package:projects/data/api/discussions_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class DiscussionsService {
  final DiscussionsApi _api = locator<DiscussionsApi>();

  Future<PageDTO<List<Discussion>>> getDiscussionsByParams({
    int startIndex,
    String query,
    String sortBy,
    String sortOrder,
    String responsibleFilter,
    String creatorFilter,
    String projectFilter,
    String milestoneFilter,
    String projectId,
    String deadlineFilter,
  }) async {
    var projects = await _api.getDiscussionsByParams(
      startIndex: startIndex,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
      // responsibleFilter: responsibleFilter,
      // creatorFilter: creatorFilter,
      // projectFilter: projectFilter,
      // milestoneFilter: milestoneFilter,
      // deadlineFilter: deadlineFilter,
      // projectId: projectId,
    );

    var success = projects.response != null;

    if (success) {
      return projects;
    } else {
      ErrorDialog.show(projects.error);
      return null;
    }
  }

  // Future<PageDTO<List<Discussion>>> searchTasks({
  //   int startIndex,
  //   String query,
  //   // String sortBy,
  //   // String sortOrder,
  //   // String responsibleFilter,
  //   // String creatorFilter,
  //   // String projectFilter,
  //   // String milestoneFilter,
  //   // String projectId,
  //   // String deadlineFilter,
  // }) async {
  //   var projects = await _api.getDiscussionsByParams(
  //     startIndex: startIndex,
  //     query: query,
  //     // sortBy: sortBy,
  //     // sortOrder: sortOrder,
  //     // responsibleFilter: responsibleFilter,
  //     // creatorFilter: creatorFilter,
  //     // projectFilter: projectFilter,
  //     // milestoneFilter: milestoneFilter,
  //     // deadlineFilter: deadlineFilter,
  //     // projectId: projectId,
  //   );

  //   var success = projects.response != null;

  //   if (success) {
  //     return projects;
  //   } else {
  //     ErrorDialog.show(projects.error);
  //     return null;
  //   }
  // }

}