import 'dart:async';

import 'package:only_office_mobile/data/api/project_api.dart';
import 'package:only_office_mobile/data/models/apiDTO.dart';
import 'package:only_office_mobile/data/models/project.dart';
import 'package:only_office_mobile/domain/dialogs.dart';
import 'package:only_office_mobile/internal/locator.dart';

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
}
