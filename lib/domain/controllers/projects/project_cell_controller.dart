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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/projects/project_status_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectCellController extends BaseProjectEditorController {
  RefreshController refreshController = RefreshController();

  void setup(ProjectDetailed project) {
    _project = project;

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      isPrivate.value = project.isPrivate!;
      status.value = project.status!;
      canEdit.value = project.canEdit!;
      statusNameString.value = ProjectStatus.toName(_project.status);
      statusImageString.value = ProjectStatus.toImageString(_project.status);
    });
  }

  late ProjectDetailed _project;

  @override
  ProjectDetailed get projectData => _project;

  final canEdit = false.obs;
  final status = RxInt(ProjectStatusCode.open.index);

  final statusImageString = RxString(ProjectStatus.toImageString(ProjectStatusCode.open.index));
  final statusNameString = RxString(tr('statusOpen'));

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }

  @override
  Future<bool> updateStatus({int? newStatusId}) async {
    final resp = await Get.find<ProjectStatusesController>()
        .updateStatus(newStatusId: newStatusId, projectData: projectData);

    if (resp) {
      _project.status = newStatusId;
      status.value = newStatusId!;
      statusNameString.value = ProjectStatus.toName(_project.status);
      statusImageString.value = ProjectStatus.toImageString(_project.status);
    }

    return resp;
  }

  @override
  Future<void> showTags() {
    // TODO: implement showTags
    throw UnimplementedError();
  }
}
