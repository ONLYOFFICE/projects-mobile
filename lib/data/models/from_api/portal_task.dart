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

import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project_owner.dart';

class PortalTask {
  int? customTaskStatus;
  int? id;
  int? milestoneId;
  int? priority;
  int? status;
  bool? canCreateComment;
  bool? canCreateSubtask;
  bool? canCreateTimeSpend;
  bool? canDelete;
  bool? canEdit;
  bool? canEditFiles;
  bool? canReadFiles;
  bool? isSubscribed;
  String? created;
  String? deadline;
  String? description;
  String? startDate;
  String? title;
  String? updated;
  List<PortalComment>? comments;
  List<PortalFile>? files;
  List<PortalUser?>? responsibles;
  List<Subtask>? subtasks;
  Milestone? milestone;
  PortalUser? createdBy;
  PortalUser? responsible;
  PortalUser? updatedBy;
  ProjectOwner? projectOwner;

  PortalTask(
      {this.canCreateSubtask,
      this.canCreateTimeSpend,
      this.canDelete,
      this.canEdit,
      this.canReadFiles,
      this.comments,
      this.created,
      this.createdBy,
      this.customTaskStatus,
      this.deadline,
      this.description,
      this.files,
      this.id,
      this.isSubscribed,
      this.milestone,
      this.milestoneId,
      this.priority,
      this.projectOwner,
      this.responsible,
      this.responsibles,
      this.startDate,
      this.status,
      this.title,
      this.updated,
      this.updatedBy});

  PortalTask.fromJson(Map<String, dynamic> json) {
    canEdit = json['canEdit'] as bool?;
    canCreateSubtask = json['canCreateSubtask'] as bool?;
    canCreateTimeSpend = json['canCreateTimeSpend'] as bool?;
    canDelete = json['canDelete'] as bool?;
    canReadFiles = json['canReadFiles'] as bool?;
    comments = json['comments'] != null
        ? ((json['comments'] as List).cast<Map<String, dynamic>>())
            .map(PortalComment.fromJson)
            .toList()
        : null;
    customTaskStatus = json['customTaskStatus'] as int?;
    startDate = json['startDate'] as String?;
    files = json['files'] != null
        ? ((json['files'] as List).cast<Map<String, dynamic>>()).map(PortalFile.fromJson).toList()
        : null;
    id = json['id'] as int?;
    isSubscribed = json['isSubscribed'] as bool?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    deadline = json['deadline'] as String?;
    priority = json['priority'] as int?;
    milestone = json['milestone'] != null
        ? Milestone.fromJson(json['milestone'] as Map<String, dynamic>)
        : null;
    milestoneId = json['milestoneId'] as int?;
    projectOwner = json['projectOwner'] != null
        ? ProjectOwner.fromJson(json['projectOwner'] as Map<String, dynamic>)
        : null;
    status = json['status'] as int?;
    responsible = json['responsible'] != null
        ? PortalUser.fromJson(json['responsible'] as Map<String, dynamic>)
        : null;
    updatedBy = json['updatedBy'] != null
        ? PortalUser.fromJson(json['updatedBy'] as Map<String, dynamic>)
        : null;
    created = json['created'] as String?;
    createdBy = json['createdBy'] != null
        ? PortalUser.fromJson(json['createdBy'] as Map<String, dynamic>)
        : null;
    updated = json['updated'] as String?;

    subtasks = json['subtasks'] != null
        ? ((json['subtasks'] as List).cast<Map<String, dynamic>>()).map(Subtask.fromJson).toList()
        : null;

    responsibles = json['responsibles'] != null
        ? ((json['responsibles'] as List).cast<Map<String, dynamic>>())
            .map(PortalUser.fromJson)
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['canEdit'] = canEdit;
    data['canCreateSubtask'] = canCreateSubtask;
    data['canCreateTimeSpend'] = canCreateTimeSpend;
    data['canDelete'] = canDelete;
    data['canReadFiles'] = canReadFiles;
    data['customTaskStatus'] = customTaskStatus;
    data['comments'] = comments?.toSet();
    data['startDate'] = startDate;
    data['files'] = files?.toSet();
    data['id'] = id;
    data['isSubscribed'] = isSubscribed;
    data['title'] = title;
    data['description'] = description;
    data['deadline'] = deadline;
    data['priority'] = priority;
    if (milestone != null) data['milestone'] = milestone!.toJson();
    data['milestoneId'] = milestoneId;
    if (projectOwner != null) {
      data['projectOwner'] = projectOwner!.toJson();
    }
    data['status'] = status;
    if (responsible != null) {
      data['responsible'] = responsible!.toJson();
    }
    if (updatedBy != null) {
      data['updatedBy'] = updatedBy!.toJson();
    }
    data['created'] = created;
    if (createdBy != null) {
      data['createdBy'] = createdBy!.toJson();
    }

    data['subtasks'] = List<dynamic>.from(subtasks!.map((x) => x.toJson()));

    data['updated'] = updated;
    return data;
  }

  bool get hasOpenSubtasks {
    for (final item in subtasks!) {
      if (item.status != 2) return true;
    }
    return false;
  }
}

class Subtask {
  final bool? canEdit;
  final int? taskId;
  final int? id;
  final String? title;
  final dynamic description;
  final int? status;
  final PortalUser? responsible;
  final DateTime? created;
  final PortalUser? createdBy;
  final PortalUser? updatedBy;
  final DateTime? updated;

  Subtask({
    this.canEdit,
    this.taskId,
    this.id,
    this.title,
    this.description,
    this.status,
    this.responsible,
    this.created,
    this.createdBy,
    this.updatedBy,
    this.updated,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) => Subtask(
        canEdit: json['canEdit'] as bool?,
        taskId: json['taskId'] as int?,
        id: json['id'] as int?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        status: json['status'] as int?,
        responsible: json['responsible'] == null
            ? null
            : PortalUser.fromJson(json['responsible'] as Map<String, dynamic>),
        updatedBy: json['updatedBy'] == null
            ? null
            : PortalUser.fromJson(json['updatedBy'] as Map<String, dynamic>),
        created: json['created'] == null ? null : DateTime.parse(json['created'] as String),
        createdBy: json['createdBy'] == null
            ? null
            : PortalUser.fromJson(json['createdBy'] as Map<String, dynamic>),
        updated: json['updated'] == null ? null : DateTime.parse(json['updated'] as String),
      );

  Map<String, dynamic> toJson() => {
        'canEdit': canEdit,
        'taskId': taskId,
        'id': id,
        'title': title,
        'description': description,
        'status': status,
        'responsible': responsible == null ? null : responsible!.toJson(),
        'updatedBy': updatedBy == null ? null : updatedBy!.toJson(),
        'created': created == null ? null : created!.toIso8601String(),
        'createdBy': createdBy == null ? null : createdBy!.toJson(),
        'updated': updated == null ? null : updated!.toIso8601String(),
      };
}
