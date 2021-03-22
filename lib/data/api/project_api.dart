import 'dart:convert';

import 'package:only_office_mobile/data/models/apiDTO.dart';
import 'package:only_office_mobile/data/models/from_api/project.dart';
import 'package:only_office_mobile/data/models/from_api/project_detailed.dart';
import 'package:only_office_mobile/data/models/from_api/status.dart';
import 'package:only_office_mobile/data/models/from_api/task.dart';
import 'package:only_office_mobile/internal/locator.dart';
import 'package:only_office_mobile/data/api/core_api.dart';
import 'package:only_office_mobile/data/models/from_api/error.dart';

class ProjectApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<List<Project>>> getProjects() async {
    var url = await coreApi.projectsUrl();

    var result = new ApiDTO<List<Project>>();
    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => Project.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson);
      }
    } catch (e) {
      result.error = new CustomError(message: 'Ошибка');
    }

    return result;
  }

  Future<ApiDTO<List<ProjectDetailed>>> getProjectsByParams() async {
// ?tag=1234
// &participant=9924256A-739C-462b-AF15-E652A3B1B6EB
// &manager=9924256A-739C-462b-AF15-E652A3B1B6EB
// &departament=9924256A-739C-462b-AF15-E652A3B1B6EB
// &follow=True

    var url = await coreApi.projectsByParamsUrl("");
    var result = await new ApiDTO<List<ProjectDetailed>>();
    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => ProjectDetailed.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson);
      }
    } catch (e) {
      result.error = new CustomError(message: 'Ошибка');
    }

    return result;
  }

  Future<ApiDTO<List<Status>>> getStatuses() async {
    var url = await coreApi.statusesUrl();
    var result = new ApiDTO<List<Status>>();
    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => Status.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson);
      }
    } catch (e) {
      result.error = new CustomError(message: 'Ошибка');
    }

    return result;
  }

//   GET api/2.0/project/task/filter
// ?projectid=1234
// &tag=1234
// &departament=9924256A-739C-462b-AF15-E652A3B1B6EB
// &creator=9924256A-739C-462b-AF15-E652A3B1B6EB
// &deadlineStart=2008-04-10T06-30-00.000Z
// &deadlineStop=2008-04-10T06-30-00.000Z
// &lastId=1234
// &myProjects=True
// &myMilestones=True
// &nomilestone=True
// &follow=True
// Host: yourportal.onlyoffice.com
// Content-Type: application/json
// Accept: application/json
  Future<ApiDTO<List<PortalTask>>> getTasksByFilter(
      {String participant}) async {
    var url = await coreApi.tasksByFilterUrl("&participant=${participant}");
    var result = new ApiDTO<List<PortalTask>>();
    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => PortalTask.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson);
      }
    } catch (e) {
      result.error = new CustomError(message: 'Ошибка');
    }

    return result;
  }
}
