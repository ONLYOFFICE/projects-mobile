import 'dart:async';

import 'package:projects/data/api/project_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/project.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class ProjectService {
  ProjectApi _api = locator<ProjectApi>();

  Future<List<Project>> getProjects() async {
    ApiDTO<List<Project>> projects = await _api.getProjects();

    var success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      ErrorDialog.show(projects.error);
      return null;
    }
  }

  Future<List<ProjectDetailed>> getProjectsByParams() async {
    ApiDTO<List<ProjectDetailed>> projects = await _api.getProjectsByParams();

    var success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      ErrorDialog.show(projects.error);
      return null;
    }
  }

  Future<List<Status>> getStatuses() async {
    ApiDTO<List<Status>> projects = await _api.getStatuses();

    var success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      ErrorDialog.show(projects.error);
      return null;
    }
  }

  Future<List<PortalTask>> getTasksByParams({String participant = ''}) async {
    ApiDTO<List<PortalTask>> projects =
        await _api.getTasksByFilter(participant: participant);

    var success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      ErrorDialog.show(projects.error);
      return null;
    }
  }
}
