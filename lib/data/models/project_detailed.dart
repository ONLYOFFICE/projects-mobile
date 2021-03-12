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
import 'package:only_office_mobile/data/models/user.dart';

class ProjectDetailed {
  bool canEdit;
  bool canDelete;
  Map<String, dynamic> security;
  String projectFolder;
  int id;
  String title;
  String description;
  int status;
  User responsible;
  bool isPrivate;
  int taskCount;
  int taskCountTotal;
  int milestoneCount;
  int discussionCount;
  int participantCount;
  String timeTrackingTotal;
  int documentsCount;
  bool isFollow;
  User updatedBy;
  String created;
  User createdBy;
  String updated;

  ProjectDetailed(
      {this.canEdit,
      this.canDelete,
      this.security,
      this.projectFolder,
      this.id,
      this.title,
      this.description,
      this.status,
      this.responsible,
      this.isPrivate,
      this.taskCount,
      this.taskCountTotal,
      this.milestoneCount,
      this.discussionCount,
      this.participantCount,
      this.timeTrackingTotal,
      this.documentsCount,
      this.isFollow,
      this.updatedBy,
      this.created,
      this.createdBy,
      this.updated});

  ProjectDetailed.fromJson(Map<String, dynamic> json) {
    canEdit = json['canEdit'];
    canDelete = json['canDelete'];
    security = json['security'];

    projectFolder = json['projectFolder'];
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    responsible = json['responsible'] != null
        ? new User.fromJson(json['responsible'])
        : null;
    isPrivate = json['isPrivate'];
    taskCount = json['taskCount'];
    taskCountTotal = json['taskCountTotal'];
    milestoneCount = json['milestoneCount'];
    discussionCount = json['discussionCount'];
    participantCount = json['participantCount'];
    timeTrackingTotal = json['timeTrackingTotal'];
    documentsCount = json['documentsCount'];
    isFollow = json['isFollow'];
    updatedBy =
        json['updatedBy'] != null ? new User.fromJson(json['updatedBy']) : null;
    created = json['created'];
    createdBy =
        json['createdBy'] != null ? new User.fromJson(json['createdBy']) : null;
    updated = json['updated'];
  }

  String createdDate() {
    final DateTime now = DateTime.parse(created);
    final DateFormat formatter = DateFormat('d MMM.yyy');
    return formatter.format(now);
  }
}
