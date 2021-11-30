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

class PortalFile {
  bool? shared;
  DateTime? created;
  DateTime? updated;
  dynamic comment;
  int? access;
  int? fileStatus;
  int? fileType;
  int? folderId;
  int? id;
  int? pureContentLength;
  int? rootFolderType;
  int? version;
  int? versionGroup;
  PortalUser? createdBy;
  PortalUser? updatedBy;
  String? contentLength;
  String? fileExst;
  String? title;
  String? thumbnailUrl;
  String? viewUrl;

  PortalFile({
    this.access,
    this.comment,
    this.contentLength,
    this.created,
    this.createdBy,
    this.fileExst,
    this.fileStatus,
    this.fileType,
    this.id,
    this.pureContentLength,
    this.rootFolderType,
    this.shared,
    this.title,
    this.thumbnailUrl,
    this.updated,
    this.updatedBy,
    this.version,
    this.versionGroup,
    this.viewUrl,
    this.folderId,
  });

  factory PortalFile.fromJson(Map<String, dynamic> json) => PortalFile(
        access: json['access'] as int?,
        comment: json['comment'] as dynamic,
        contentLength: json['contentLength'] as String?,
        created: DateTime.parse(json['created'] as String),
        createdBy: json['createdBy'] != null
            ? PortalUser.fromJson(json['createdBy'] as Map<String, dynamic>)
            : null,
        fileExst: json['fileExst'] as String?,
        fileStatus: json['fileStatus'] as int?,
        fileType: json['fileType'] as int?,
        id: json['id'] as int?,
        pureContentLength: json['pureContentLength'] as int?,
        rootFolderType: json['rootFolderType'] as int?,
        shared: json['shared'] as bool?,
        title: json['title'] as String?,
        thumbnailUrl: json['thumbnailUrl'] as String?,
        updated: DateTime.parse(json['updated'] as String),
        updatedBy: json['updatedBy'] != null
            ? PortalUser.fromJson(json['updatedBy'] as Map<String, dynamic>)
            : null,
        version: json['version'] as int?,
        versionGroup: json['versionGroup'] as int?,
        viewUrl: json['viewUrl'] as String?,
        folderId: json['folderId'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'access': access,
        'comment': comment,
        'contentLength': contentLength,
        'created': created?.toIso8601String(),
        'createdBy': createdBy?.toJson(),
        'fileExst': fileExst,
        'fileStatus': fileStatus,
        'fileType': fileType,
        'folderId': folderId,
        'id': id,
        'pureContentLength': pureContentLength,
        'rootFolderType': rootFolderType,
        'shared': shared,
        'title': title,
        'thumbnailUrl': thumbnailUrl,
        'updated': updated?.toIso8601String(),
        'updatedBy': updatedBy?.toJson(),
        'version': version,
        'versionGroup': versionGroup,
        'viewUrl': viewUrl,
      };
}
