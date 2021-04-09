import 'dart:async';

import 'package:projects/data/api/project_api.dart';
import 'package:projects/data/models/apiDTO.dart';
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

  Future<ProjectsApiDTO<List<ProjectDetailed>>> getProjectsByParams(
      {int startIndex, String query}) async {
    var projects =
        await _api.getProjectsByParams(startIndex: startIndex, query: query);

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

  Future<List<Status>> getStatuses() async {
    var projects = await _api.getStatuses();

    var success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      ErrorDialog.show(projects.error);
      return null;
    }
  }

  Future<List<Status>> getProjectStatuses() async {
    var projects = await _api.getStatuses();

    var success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      ErrorDialog.show(projects.error);
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
