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

import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project_owner.dart';

class Milestone {
  Milestone({
    this.activeTaskCount,
    this.canDelete,
    this.canEdit,
    this.closedTaskCount,
    this.created,
    this.createdBy,
    this.deadline,
    this.description,
    this.id,
    this.isKey,
    this.isNotify,
    this.projectOwner,
    this.responsible,
    this.status,
    this.title,
    this.updated,
    this.updatedBy,
  });

  bool? canDelete;
  bool? canEdit;
  bool? isKey;
  bool? isNotify;
  DateTime? created;
  DateTime? deadline;
  DateTime? updated;
  int? activeTaskCount;
  int? closedTaskCount;
  int? id;
  int? status;
  PortalUser? createdBy;
  PortalUser? responsible;
  PortalUser? updatedBy;
  ProjectOwner? projectOwner;
  String? description;
  String? title;

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
        canEdit: json['canEdit'] as bool?,
        canDelete: json['canDelete'] as bool?,
        id: json['id'] as int?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        deadline: json['deadline'] != null
            ? DateTime.parse(json['deadline'] as String)
            : null,
        isKey: json['isKey'] as bool?,
        isNotify: json['isNotify'] as bool?,
        activeTaskCount: json['activeTaskCount'] as int?,
        closedTaskCount: json['closedTaskCount'] as int?,
        status: json['status'] as int?,
        created: json['created'] != null
            ? DateTime.parse(json['created'] as String)
            : null,
        createdBy: json['createdBy'] != null
            ? PortalUser.fromJson(json['createdBy'] as Map<String, dynamic>)
            : null,
        projectOwner: json['projectOwner'] != null
            ? ProjectOwner.fromJson(
                json['projectOwner'] as Map<String, dynamic>)
            : null,
        responsible: json['responsible'] != null
            ? PortalUser.fromJson(json['responsible'] as Map<String, dynamic>)
            : null,
        updatedBy: json['updatedBy'] != null
            ? PortalUser.fromJson(json['updatedBy'] as Map<String, dynamic>)
            : null,
        updated: json['updated'] != null
            ? DateTime.parse(json['updated'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'activeTaskCount': activeTaskCount,
        'canDelete': canDelete,
        'canEdit': canEdit,
        'closedTaskCount': closedTaskCount,
        'created': created?.toIso8601String(),
        'createdBy': createdBy?.toJson(),
        'deadline': deadline?.toIso8601String(),
        'description': description,
        'id': id,
        'isKey': isKey,
        'isNotify': isNotify,
        'responsible': responsible?.toJson(),
        'status': status,
        'title': title,
        'updated': updated?.toIso8601String(),
        'updatedBy': updatedBy?.toJson(),
        if (projectOwner != null) 'projectOwner': projectOwner!.toJson(),
        if (responsible != null) 'responsible': responsible!.toJson(),
        if (updatedBy != null) 'updatedBy': updatedBy!.toJson(),
        if (createdBy != null) 'createdBy': createdBy!.toJson()
      };
}
