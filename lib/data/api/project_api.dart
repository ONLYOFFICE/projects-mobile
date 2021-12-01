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
    final url = await locator.get<CoreApi>().projectsUrl();

    final result = ApiDTO<List<Project>>();
    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => Project.fromJson(i as Map<String, dynamic>))
            .toList();
      } else {
        result.error = response as CustomError;
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
    int? startIndex,
    String? query,
    String? sortBy,
    String? sortOrder,
    String? projectManagerFilter,
    String? participantFilter,
    String? otherFilter,
    String? statusFilter,
  }) async {
    var url = await locator.get<CoreApi>().projectsByParamsBaseUrl();

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

    final result = PageDTO<List<ProjectDetailed>>();
    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.total = responseJson['total'] as int;

        result.response = (responseJson['response'] as List)
            .map((i) => ProjectDetailed.fromJson(i as Map<String, dynamic>))
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<ProjectDetailed>> getProjectById(
      {required int projectId}) async {
    final url = await locator.get<CoreApi>().projectByIdUrl(projectId);

    final result = ApiDTO<ProjectDetailed>();
    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        {
          final responseJson = json.decode(response.body);
          result.response = ProjectDetailed.fromJson(
              responseJson['response'] as Map<String, dynamic>);
        }
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<Status>>> getStatuses() async {
    final url = await locator.get<CoreApi>().statusesUrl();
    final result = ApiDTO<List<Status>>();
    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => Status.fromJson(i as Map<String, dynamic>))
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<ProjectTag>>> getProjectTags() async {
    final url = await locator.get<CoreApi>().projectTags();
    final result = ApiDTO<List<ProjectTag>>();
    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => ProjectTag.fromJson(i as Map<String, dynamic>))
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<PageDTO<List<ProjectTag>>> getTagsPaginated({
    int? startIndex,
    String? query,
  }) async {
    var url = await locator.get<CoreApi>().projectTags();

    if (query != null) url += '/search?tagName=$query';

    if (startIndex != null) url += '?&Count=25&StartIndex=$startIndex';

    final result = PageDTO<List<ProjectTag>>();
    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => ProjectTag.fromJson(i as Map<String, dynamic>))
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<ProjectDetailed>> createProject({required NewProjectDTO project}) async {
    final url = await locator.get<CoreApi>().createProjectUrl();

    final result = ApiDTO<ProjectDetailed>();
    final body = project.toJson();

    try {
      final response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = ProjectDetailed.fromJson(
            responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<Map<String, dynamic>>> editProject(
      {required EditProjectDTO project, required int projectId}) async {
    final url = await locator.get<CoreApi>().projectByIdUrl(projectId);

    final result = ApiDTO<Map<String, dynamic>>();
    final body = project.toJson();

    try {
      final response = await locator.get<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = responseJson['response'] as Map<String, dynamic>;
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<PortalUser>>> getProjectTeam(
      {required int projectID}) async {
    final url =
        await locator.get<CoreApi>().projectTeamUrl(projectID: projectID);

    final result = ApiDTO<List<PortalUser>>();
    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => PortalUser.fromJson(i as Map<String, dynamic>))
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalUser>> deleteProject({required int projectId}) async {
    final url = await locator.get<CoreApi>().projectByIDUrl(projectId);

    final result = ApiDTO<PortalUser>();

    try {
      final response = await locator.get<CoreApi>().deleteRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = PortalUser.fromJson(
            responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<ProjectDetailed>> updateProjectStatus(
      {required int projectId, required String newStatus}) async {
    final url = await locator
        .get<CoreApi>()
        .updateProjectStatusUrl(projectId: projectId);

    final result = ApiDTO<ProjectDetailed>();
    final body = {'status': newStatus};

    try {
      final response = await locator.get<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = ProjectDetailed.fromJson(
            responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<FollowProject>> followProject({required int projectId}) async {
    final url =
        await locator.get<CoreApi>().followProjectUrl(projectId: projectId);

    final result = ApiDTO<FollowProject>();

    try {
      final response = await locator.get<CoreApi>().putRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = FollowProject.fromJson(
            responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<ProjectTag>> createTag({required String name}) async {
    final url = await locator.get<CoreApi>().createTagUrl();

    final result = ApiDTO<ProjectTag>();

    final body = {'data': name};

    try {
      final response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = ProjectTag.fromJson(
            responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<PortalUser>>> addToProjectTeam(
      {required int projectID, required List<String> users}) async {
    final url =
        await locator.get<CoreApi>().projectTeamUrl(projectID: projectID);

    final result = ApiDTO<List<PortalUser>>();

    final body = {'participants': users, 'notify': true};

    try {
      final response = await locator.get<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => PortalUser.fromJson(i as Map<String, dynamic>))
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<SecurityInfo>> getProjectSecurityinfo() async {
    final url = await locator.get<CoreApi>().getProjectSecurityInfoUrl();

    final result = ApiDTO<SecurityInfo>();
    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = SecurityInfo.fromJson(
            responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
