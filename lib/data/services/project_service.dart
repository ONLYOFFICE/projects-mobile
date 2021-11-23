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

import 'package:get/get.dart';
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

  Future<List<Project>?> getProjects() async {
    final projects = await _api.getProjects();

    final success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      await Get.find<ErrorDialog>().show(projects.error!.message);
      return null;
    }
  }

  Future<PageDTO<List<ProjectDetailed>>?> getProjectsByParams({
    int? startIndex,
    String? query,
    String? sortBy,
    String? sortOrder,
    String? projectManagerFilter,
    String? participantFilter,
    String? otherFilter,
    String? statusFilter,
  }) async {
    final projects = await _api.getProjectsByParams(
      startIndex: startIndex,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
      projectManagerFilter: projectManagerFilter,
      participantFilter: participantFilter,
      otherFilter: otherFilter,
      statusFilter: statusFilter,
    );

    final success = projects.response != null;

    if (success) {
      return projects;
    } else {
      await Get.find<ErrorDialog>().show(projects.error!.message);
      return null;
    }
  }

  Future<ProjectDetailed?> getProjectById({required int projectId}) async {
    final projects = await _api.getProjectById(projectId: projectId);

    final success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      await Get.find<ErrorDialog>().show(projects.error!.message);
      return null;
    }
  }

  Future<List<ProjectTag>?> getProjectTags() async {
    final tags = await _api.getProjectTags();

    final success = tags.response != null;

    if (success) {
      return tags.response;
    } else {
      await Get.find<ErrorDialog>().show(tags.error!.message);
      return null;
    }
  }

  Future<PageDTO<List<ProjectTag>>?> getTagsPaginated({
    int? startIndex,
    String? query,
  }) async {
    final tags =
        await _api.getTagsPaginated(query: query, startIndex: startIndex);

    final success = tags.response != null;

    if (success) {
      return tags;
    } else {
      await Get.find<ErrorDialog>().show(tags.error!.message);
      return null;
    }
  }

  Future<List<PortalUser>?> getProjectTeam(int projectID) async {
    final team = await _api.getProjectTeam(projectID: projectID);

    final success = team.response != null;

    if (success) {
      return team.response;
    } else {
      await Get.find<ErrorDialog>().show(team.error!.message);
      return null;
    }
  }

  Future<List<PortalUser>?> addToProjectTeam(
      int projectID, List<String> users) async {
    final team =
        await _api.addToProjectTeam(projectID: projectID, users: users);

    final success = team.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.project
      });
      return team.response;
    } else {
      await Get.find<ErrorDialog>().show(team.error!.message);
      return null;
    }
  }

  Future createProject({required NewProjectDTO project}) async {
    final result = await _api.createProject(project: project);

    if (result.response != null) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.createEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.project
      });

      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
    }
  }

  Future<bool> editProject(
      {required EditProjectDTO project, required int projectId}) async {
    final result =
        await _api.editProject(project: project, projectId: projectId);

    final success = result.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.project
      });
      return success;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return false;
    }
  }

  Future<bool> deleteProject({required int projectId}) async {
    final result = await _api.deleteProject(projectId: projectId);

    final success = result.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.deleteEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.project
      });
      return success;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return false;
    }
  }

  Future<ProjectDetailed?> updateProjectStatus(
      {required int projectId, required String newStatus}) async {
    final result = await _api.updateProjectStatus(
        projectId: projectId, newStatus: newStatus);

    final success = result.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.project
      });
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }

  Future followProject({required int projectId}) async {
    final result = await _api.followProject(projectId: projectId);

    final success = result.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.project
      });
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }

  Future createTag({required String name}) async {
    final result = await _api.createTag(name: name);

    final success = result.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.project
      });
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }

  Future<SecurityInfo?> getProjectSecurityinfo() async {
    final result = await _api.getProjectSecurityinfo();

    final success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }
}
