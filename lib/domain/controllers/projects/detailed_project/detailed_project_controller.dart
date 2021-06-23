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

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectDetailsController extends GetxController {
  final _projectService = locator<ProjectService>();
  final _docApi = locator<FilesService>();

  RefreshController refreshController = RefreshController();
  var loaded = true.obs;

  final statuses = [].obs;

  var projectTitleText = ''.obs;
  var descriptionText = ''.obs;
  var managerText = ''.obs;
  var teamMembers = [].obs;
  var teamMembersCount = 0.obs;

  var creationDateText = ''.obs;
  var tags = [].obs;
  var statusText = ''.obs;
  var tasksCount = ''.obs;
  var docsCount = (-1).obs;
  var tagsText = ''.obs;

  var currentTab = -1.obs;

  ProjectDetailsController(this.projectDetailed);

  ProjectDetailed projectDetailed;
  ProjectDetailed get projectData => projectDetailed;

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }

  Future<void> setup() async {
    teamMembersCount.value = projectDetailed.participantCount;
    statusText.value =
        'Project ${ProjectStatus.toName(projectDetailed.status)}';

    projectTitleText.value = projectDetailed.title;
    descriptionText.value = projectDetailed.description;
    managerText.value = projectDetailed.responsible.displayName;

    final formatter = DateFormat('dd MMM yyyy');
    creationDateText.value =
        formatter.format(DateTime.parse(projectDetailed.created));

    await _projectService
        .getProjectById(projectId: projectDetailed.id)
        .then((value) => {
              if (value?.tags != null)
                {
                  tags.addAll(value.tags),
                  tagsText.value = value.tags.join(', '),
                }
            });

    tasksCount.value = projectDetailed.taskCount.toString();

    await _docApi
        .getFilesByParams(folderId: projectDetailed.projectFolder)
        .then((value) => docsCount.value = value.files.length);
  }

  void createNewMilestone() {
    Get.toNamed('NewMilestoneView');
  }

  void createTask() {
    Get.toNamed('NewTaskView');
  }

  Future<void> copyLink() async {}

  Future deleteProject() async {
    return await _projectService.deleteProject(projectId: projectDetailed.id);
  }

  Future updateStatus({int newStatusId}) async {
    var t = await _projectService.updateProjectStatus(
        projectId: projectDetailed.id,
        newStatus: ProjectStatus.toName(newStatusId));

    if (t != null) {
      projectDetailed.status = t.status;
    }
  }
}
