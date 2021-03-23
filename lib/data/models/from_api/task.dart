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

import 'package:intl/intl.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project_owner.dart';

class PortalTask {
  bool canEdit;
  bool canCreateSubtask;
  bool canCreateTimeSpend;
  bool canDelete;
  bool canReadFiles;
  String startDate;
  int id;
  String title;
  String description;
  String deadline;
  int priority;
  int milestoneId;
  ProjectOwner projectOwner;
  int status;
  PortalUser responsible;
  PortalUser updatedBy;
  String created;
  PortalUser createdBy;
  String updated;
  List<PortalUser> responsibles;

  PortalTask(
      {this.canEdit,
      this.canCreateSubtask,
      this.canCreateTimeSpend,
      this.canDelete,
      this.canReadFiles,
      this.startDate,
      this.id,
      this.title,
      this.description,
      this.deadline,
      this.priority,
      this.milestoneId,
      this.projectOwner,
      this.status,
      this.responsible,
      this.updatedBy,
      this.created,
      this.createdBy,
      this.updated,
      this.responsibles});

  PortalTask.fromJson(Map<String, dynamic> json) {
    canEdit = json['canEdit'];
    canCreateSubtask = json['canCreateSubtask'];
    canCreateTimeSpend = json['canCreateTimeSpend'];
    canDelete = json['canDelete'];
    canReadFiles = json['canReadFiles'];
    startDate = json['startDate'];
    id = json['id'];
    title = json['title'];
    description = json['description'];
    deadline = json['deadline'];
    priority = json['priority'];
    milestoneId = json['milestoneId'];
    projectOwner = json['projectOwner'] != null
        ? ProjectOwner.fromJson(json['projectOwner'])
        : null;
    status = json['status'];
    responsible = json['responsible'] != null
        ? PortalUser.fromJson(json['responsible'])
        : null;
    updatedBy = json['updatedBy'] != null
        ? PortalUser.fromJson(json['updatedBy'])
        : null;
    created = json['created'];
    createdBy = json['createdBy'] != null
        ? PortalUser.fromJson(json['createdBy'])
        : null;
    updated = json['updated'];

    responsibles = json['responsibles'] != null
        ? (json['responsibles'] as List)
            .map((i) => PortalUser.fromJson(i))
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
    data['startDate'] = startDate;
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['deadline'] = deadline;
    data['priority'] = priority;
    data['milestoneId'] = milestoneId;
    if (projectOwner != null) {
      data['projectOwner'] = projectOwner.toJson();
    }
    data['status'] = status;
    if (responsible != null) {
      data['responsible'] = responsible.toJson();
    }
    if (updatedBy != null) {
      data['updatedBy'] = updatedBy.toJson();
    }
    data['created'] = created;
    if (createdBy != null) {
      data['createdBy'] = createdBy.toJson();
    }
    data['updated'] = updated;
    return data;
  }

  String creationDate() {
    final now = DateTime.parse(created);
    final formatter = DateFormat('d MMM.yyy');
    return formatter.format(now);
  }
}
