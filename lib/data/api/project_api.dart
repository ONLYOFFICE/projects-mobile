/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/folow_project.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/from_api/project_tag.dart';
import 'package:projects/data/models/from_api/security_info.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class ProjectApi {
  Future<ApiDTO<List<Project>>> getProjects() async {
    var url = await locator<CoreApi>().projectsUrl();

    var result = ApiDTO<List<Project>>();
    try {
      var response = await locator<CoreApi>().getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => Project.fromJson(i))
            .toList();
      } else {
        result.error = (response as CustomError);
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
    var url = await locator<CoreApi>().projectsByParamsBaseUrl();

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
      var response = await locator<CoreApi>().getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.total = responseJson['total'];

        result.response = (responseJson['response'] as List)
            .map((i) => ProjectDetailed.fromJson(i))
            .toList();
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<ProjectDetailed>> getProjectById({int projectId}) async {
    var url = await locator<CoreApi>().projectByIdUrl(projectId);

    var result = ApiDTO<ProjectDetailed>();
    try {
      var response = await locator<CoreApi>().getRequest(url);

      if (response is http.Response) {
        {
          var responseJson = json.decode(response.body);
          result.response = ProjectDetailed.fromJson(responseJson['response']);
        }
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<Status>>> getStatuses() async {
    var url = await locator<CoreApi>().statusesUrl();
    var result = ApiDTO<List<Status>>();
    try {
      var response = await locator<CoreApi>().getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => Status.fromJson(i))
            .toList();
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<ProjectTag>>> getProjectTags() async {
    var url = await locator<CoreApi>().projectTags();
    var result = ApiDTO<List<ProjectTag>>();
    try {
      var response = await locator<CoreApi>().getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => ProjectTag.fromJson(i))
            .toList();
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<PageDTO<List<ProjectTag>>> getTagsPaginated({
    int startIndex,
    String query,
  }) async {
    var url = await locator<CoreApi>().projectTags();

    if (query != null) url += '/search?tagName=$query';

    if (startIndex != null) url += '?&Count=25&StartIndex=$startIndex';

    var result = PageDTO<List<ProjectTag>>();
    try {
      var response = await locator<CoreApi>().getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => ProjectTag.fromJson(i))
            .toList();
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<ProjectDetailed>> createProject({NewProjectDTO project}) async {
    var url = await locator<CoreApi>().createProjectUrl();

    var result = ApiDTO<ProjectDetailed>();
    var body = project.toJson();

    try {
      var response = await locator<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = ProjectDetailed.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<Map<String, dynamic>>> editProject(
      {EditProjectDTO project, int projectId}) async {
    var url = await locator<CoreApi>().projectByIdUrl(projectId);

    var result = ApiDTO<Map<String, dynamic>>();
    var body = project.toJson();

    try {
      var response = await locator<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = responseJson['response'];
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<PortalUser>>> getProjectTeam(String projectID) async {
    var url = await locator<CoreApi>().projectTeamUrl(projectID);

    var result = ApiDTO<List<PortalUser>>();
    try {
      var response = await locator<CoreApi>().getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => PortalUser.fromJson(i))
            .toList();
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalUser>> deleteProject({int projectId}) async {
    var url = await locator<CoreApi>().projectByIDUrl(projectId);

    var result = ApiDTO<PortalUser>();

    try {
      var response = await locator<CoreApi>().deleteRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = PortalUser.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<ProjectDetailed>> updateProjectStatus(
      {int projectId, String newStatus}) async {
    var url = await locator<CoreApi>().updateProjectStatusUrl(projectId);

    var result = ApiDTO<ProjectDetailed>();
    var body = {'status': newStatus};

    try {
      var response = await locator<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = ProjectDetailed.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<FollowProject>> followProject({int projectId}) async {
    var url = await locator<CoreApi>().followProjectUrl(projectId);

    var result = ApiDTO<FollowProject>();

    try {
      var response = await locator<CoreApi>().putRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = FollowProject.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<ProjectTag>> createTag({String name}) async {
    var url = await locator<CoreApi>().createTagUrl();

    var result = ApiDTO<ProjectTag>();

    var body = {'data': name};

    try {
      var response = await locator<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = ProjectTag.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<PortalUser>>> addToProjectTeam(
      String projectID, List<String> users) async {
    var url = await locator<CoreApi>().projectTeamUrl(projectID);

    var result = ApiDTO<List<PortalUser>>();

    var body = {'participants': users, 'notify': true};

    try {
      var response = await locator<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => PortalUser.fromJson(i))
            .toList();
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<SecrityInfo>> getProjectSecurityinfo() async {
    var url = await locator<CoreApi>().getProjectSecurityinfoUrl();

    var result = ApiDTO<SecrityInfo>();
    try {
      var response = await locator<CoreApi>().getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = SecrityInfo.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
