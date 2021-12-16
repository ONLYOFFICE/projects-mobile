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

import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project.dart';
import 'package:projects/data/models/from_api/project_owner.dart';

class Discussion {
  Discussion({
    this.canEditFiles,
    this.canReadFiles,
    this.subscribers,
    this.files,
    this.comments,
    this.project,
    this.canCreateComment,
    this.canEdit,
    this.id,
    this.title,
    this.description,
    this.projectOwner,
    this.commentsCount,
    this.text,
    this.status,
    this.updatedBy,
    this.created,
    this.createdBy,
    this.updated,
  });

  final DateTime? created;
  final DateTime? updated;
  final PortalUser? createdBy;
  final PortalUser? updatedBy;
  final ProjectOwner? projectOwner;
  final String? text;
  final String? title;
  final bool? canCreateComment;
  final bool? canEdit;
  final bool? canEditFiles;
  final bool? canReadFiles;
  List<PortalUser>? subscribers;
  final List<PortalFile>? files;
  List<PortalComment>? comments;
  final Project? project;
  final dynamic description;
  final int? commentsCount;
  final int? id;
  int? status;

  factory Discussion.fromJson(Map<String, dynamic> json) => Discussion(
        canCreateComment: json['canCreateComment'] as bool?,
        canEditFiles: json['canEditFiles'] as bool?,
        canReadFiles: json['canReadFiles'] as bool?,
        subscribers: json['subscribers'] != null
            ? ((json['subscribers'] as List).cast<Map<String, dynamic>>())
                .map((e) => PortalUser.fromJson(e))
                .toList()
            : null,
        files: json['files'] != null
            ? ((json['files'] as List).cast<Map<String, dynamic>>())
                .map((e) => PortalFile.fromJson(e))
                .toList()
            : null,
        comments: json['comments'] != null
            ? ((json['comments'] as List).cast<Map<String, dynamic>>())
                .map((e) => PortalComment.fromJson(e))
                .toList()
            : null,
        project: json['project'] != null
            ? Project.fromJson(json['project'] as Map<String, dynamic>)
            : null,
        canEdit: json['canEdit'] as bool?,
        id: json['id'] as int?,
        title: json['title'] as String?,
        description: json['description'],
        projectOwner: json['projectOwner'] != null
            ? ProjectOwner.fromJson(json['projectOwner'] as Map<String, dynamic>)
            : null,
        commentsCount: json['commentsCount'] as int?,
        text: json['text'] as String?,
        status: json['status'] as int,
        updatedBy: json['updatedBy'] != null
            ? PortalUser.fromJson(json['updatedBy'] as Map<String, dynamic>)
            : null,
        created: json['created'] != null ? DateTime.parse(json['created'] as String) : null,
        createdBy: json['createdBy'] != null
            ? PortalUser.fromJson(json['createdBy'] as Map<String, dynamic>)
            : null,
        updated: json['updated'] != null ? DateTime.parse(json['updated'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'canCreateComment': canCreateComment,
        'canEdit': canEdit,
        'id': id,
        'title': title,
        'description': description,
        'projectOwner': projectOwner?.toJson(),
        'commentsCount': commentsCount,
        'text': text,
        'status': status,
        'updatedBy': updatedBy?.toJson(),
        'created': created?.toIso8601String(),
        'createdBy': createdBy?.toJson(),
        'updated': updated?.toIso8601String(),
      };

  set setStatus(int? newStatus) => status = newStatus;
  set setSubscribers(List<PortalUser>? newS) => subscribers = newS;
}
