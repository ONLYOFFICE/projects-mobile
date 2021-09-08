import 'dart:async';

import 'package:projects/data/api/project_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/from_api/project_tag.dart';
import 'package:projects/data/models/from_api/security_info.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class ProjectService {
  final ProjectApi _api = locator<ProjectApi>();
  final SecureStorage _secureStorage = locator<SecureStorage>();

  Future<List<Project>> getProjects() async {
    var projects = await _api.getProjects();

    var success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      await ErrorDialog.show(projects.error);
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
      await ErrorDialog.show(projects.error);
      return null;
    }
  }

  Future<ProjectDetailed> getProjectById({int projectId}) async {
    var projects = await _api.getProjectById(projectId: projectId);

    var success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      await ErrorDialog.show(projects.error);
      return null;
    }
  }

  Future<List<ProjectTag>> getProjectTags() async {
    var tags = await _api.getProjectTags();

    var success = tags.response != null;

    if (success) {
      return tags.response;
    } else {
      await ErrorDialog.show(tags.error);
      return null;
    }
  }

  Future<PageDTO<List<ProjectTag>>> getTagsPaginated({
    int startIndex,
    String query,
  }) async {
    var tags =
        await _api.getTagsPaginated(query: query, startIndex: startIndex);

    var success = tags.response != null;

    if (success) {
      return tags;
    } else {
      await ErrorDialog.show(tags.error);
      return null;
    }
  }

  Future<List<PortalUser>> getProjectTeam(String projectID) async {
    var team = await _api.getProjectTeam(projectID);

    var success = team.response != null;

    if (success) {
      return team.response;
    } else {
      await ErrorDialog.show(team.error);
      return null;
    }
  }

  Future<List<PortalUser>> addToProjectTeam(
      String projectID, List<String> users) async {
    var team = await _api.addToProjectTeam(projectID, users);

    var success = team.response != null;

    if (success) {
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal : await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity : AnalyticsService.Params.Value.project
      });
      return team.response;
    } else {
      await ErrorDialog.show(team.error);
      return null;
    }
  }

  Future<bool> createProject({NewProjectDTO project}) async {
    var result = await _api.createProject(project: project);

    var success = result.response != null;

    if (success) {
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.createEntity, {
        AnalyticsService.Params.Key.portal : await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity : AnalyticsService.Params.Value.project
      });
      return success;
    } else {
      await ErrorDialog.show(result.error);
      return false;
    }
  }

  Future<bool> editProject({EditProjectDTO project, int projectId}) async {
    var result = await _api.editProject(project: project, projectId: projectId);

    var success = result.response != null;

    if (success) {
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal : await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity : AnalyticsService.Params.Value.project
      });
      return success;
    } else {
      await ErrorDialog.show(result.error);
      return false;
    }
  }

  Future<bool> deleteProject({int projectId}) async {
    var result = await _api.deleteProject(projectId: projectId);

    var success = result.response != null;

    if (success) {
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.deleteEntity, {
        AnalyticsService.Params.Key.portal : await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity : AnalyticsService.Params.Value.project
      });
      return success;
    } else {
      await ErrorDialog.show(result.error);
      return false;
    }
  }

  Future<ProjectDetailed> updateProjectStatus(
      {int projectId, String newStatus}) async {
    var result = await _api.updateProjectStatus(
        projectId: projectId, newStatus: newStatus);

    var success = result.response != null;

    if (success) {
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal : await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity : AnalyticsService.Params.Value.project
      });
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }

  Future followProject({int projectId}) async {
    var result = await _api.followProject(projectId: projectId);

    var success = result.response != null;

    if (success) {
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal : await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity : AnalyticsService.Params.Value.project
      });
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }

  Future createTag({String name}) async {
    var result = await _api.createTag(name: name);

    var success = result.response != null;

    if (success) {
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal : await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity : AnalyticsService.Params.Value.project
      });
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }

  Future<SecrityInfo> getProjectSecurityinfo({String name}) async {
    var result = await _api.getProjectSecurityinfo();

    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }
}
