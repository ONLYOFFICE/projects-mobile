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

import 'dart:async';

import 'package:projects/data/api/project_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/from_api/project_tag.dart';
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
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }
}
