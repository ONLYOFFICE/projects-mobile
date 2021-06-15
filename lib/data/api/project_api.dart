import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/from_api/project_tag.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class ProjectApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<List<Project>>> getProjects() async {
    var url = await coreApi.projectsUrl();

    var result = ApiDTO<List<Project>>();
    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => Project.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

// ?tag=1234
// &participant=9924256A-739C-462b-AF15-E652A3B1B6EB
// &manager=9924256A-739C-462b-AF15-E652A3B1B6EB
// &departament=9924256A-739C-462b-AF15-E652A3B1B6EB
// &follow=True

//https://nct.onlyoffice.com/api/2.0/project/filter.json
// ?sortBy=create_on
// &sortOrder=ascending
// &status=open
// &Count=25
// &StartIndex=25
// &simple=true
// &__=291475
// &FilterValue=searchquerry
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
    var url = await coreApi.projectsByParamsBaseUrl();

    if (startIndex != null) {
      url += '&Count=25&StartIndex=$startIndex';
    }

    if (query != null) {
      url += '&FilterValue=$query';
    }

    if (sortBy != null &&
        sortBy.isNotEmpty &&
        sortOrder != null &&
        sortOrder.isNotEmpty) url += '&sortBy=$sortBy&sortOrder=$sortOrder';

    if (projectManagerFilter != null) {
      url += projectManagerFilter;
    }
    if (participantFilter != null) {
      url += participantFilter;
    }
    if (otherFilter != null) {
      url += otherFilter;
    }
    if (statusFilter != null) {
      url += statusFilter;
    }

    var result = PageDTO<List<ProjectDetailed>>();
    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.total = responseJson['total'];
        {
          result.response = (responseJson['response'] as List)
              .map((i) => ProjectDetailed.fromJson(i))
              .toList();
        }
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<ProjectDetailed>> getProjectById({int projectId}) async {
    var url = await coreApi.projectByIdUrl(projectId);

    var result = ApiDTO<ProjectDetailed>();
    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        {
          result.response = ProjectDetailed.fromJson(responseJson['response']);
        }
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<Status>>> getStatuses() async {
    var url = await coreApi.statusesUrl();
    var result = ApiDTO<List<Status>>();
    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => Status.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<ProjectTag>>> getProjectTags() async {
    var url = await coreApi.projectTags();
    var result = ApiDTO<List<ProjectTag>>();
    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => ProjectTag.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<Map<String, dynamic>>> createProject(
      {NewProjectDTO project}) async {
    var url = await coreApi.createProjectUrl();

    var result = ApiDTO<Map<String, dynamic>>();
    var body = project.toJson();

    try {
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 201) {
        result.response = responseJson['response'];
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<PortalUser>>> getProjectTeam(String projectID) async {
    var url = await coreApi.projectTeamUrl(projectID);

    var result = ApiDTO<List<PortalUser>>();
    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => PortalUser.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
