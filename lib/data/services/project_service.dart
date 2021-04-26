import 'dart:async';

import 'package:projects/data/api/project_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/from_api/project_tag.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class ProjectService {
  final ProjectApi _api = locator<ProjectApi>();

  Future<List<Project>> getProjects() async {
    var projects = await _api.getProjects();

    var success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      ErrorDialog.show(projects.error);
      return null;
    }
  }

  Future<PageDTO<List<ProjectDetailed>>> getProjectsByParams({
    int startIndex,
    String query,
    String sortBy,
    String sortOrder,
    String projectManagerFilter,
    String participantFilter,
    String otherFilter,
    String statusFilter,
  }) async {
    var projects = await _api.getProjectsByParams(
      startIndex: startIndex,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
      projectManagerFilter: projectManagerFilter,
      participantFilter: participantFilter,
      otherFilter: otherFilter,
      statusFilter: statusFilter,
    );

    var success = projects.response != null;

    if (success) {
      return projects;
    } else {
      ErrorDialog.show(projects.error);
      return null;
    }
  }

  Future<List<ProjectTag>> getProjectTags() async {
    var tags = await _api.getProjectTags();

    var success = tags.response != null;

    if (success) {
      return tags.response;
    } else {
      ErrorDialog.show(tags.error);
      return null;
    }
  }

  Future<List<PortalUser>> getProjectTeam(String projectID) async {
    var team = await _api.getProjectTeam(projectID);

    var success = team.response != null;

    if (success) {
      return team.response;
    } else {
      ErrorDialog.show(team.error);
      return null;
    }
  }

  Future<bool> createProject({NewProjectDTO project}) async {
    var result = await _api.createProject(project: project);

    var success = result.response != null;

    if (success) {
      return success;
    } else {
      ErrorDialog.show(result.error);
      return false;
    }
  }
}
