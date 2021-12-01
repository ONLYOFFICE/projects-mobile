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

import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/models/from_api/portal_user.dart';

class FoldersResponse {
  List<PortalFile>? files;
  List<Folder>? folders;
  Folder? current;
  List<int>? pathParts;
  int? startIndex;
  int? count;
  int? total;

  FoldersResponse(
      {this.files,
      this.folders,
      this.current,
      this.pathParts,
      this.startIndex,
      this.count,
      this.total});

  FoldersResponse.fromJson(Map<String, dynamic> json) {
    if (json['files'] != null) {
      files = <PortalFile>[];
      json['files'].forEach((e) {
        files!.add(PortalFile.fromJson(e as Map<String, dynamic>));
      });
    }
    if (json['folders'] != null) {
      folders = <Folder>[];
      json['folders'].forEach((e) {
        folders!.add(Folder.fromJson(e as Map<String, dynamic>));
      });
    }
    current = json['current'] != null
        ? Folder.fromJson(json['current'] as Map<String, dynamic>)
        : null;
    pathParts = (json['pathParts'] as List).cast<int>();
    startIndex = json['startIndex'] as int?;
    count = json['count'] as int?;
    total = json['total'] as int?;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    if (folders != null) {
      data['folders'] = folders!.map((v) => v.toJson()).toList();
    }
    if (current != null) {
      data['current'] = current!.toJson();
    }
    data['pathParts'] = pathParts;
    data['startIndex'] = startIndex;
    data['count'] = count;
    data['total'] = total;
    return data;
  }
}

class Folder {
  int? parentId;
  int? filesCount;
  int? foldersCount;
  int? id;
  String? title;
  int? access;
  bool? shared;
  int? rootFolderType;
  PortalUser? updatedBy;
  DateTime? created;
  PortalUser? createdBy;
  DateTime? updated;

  Folder(
      {this.parentId,
      this.filesCount,
      this.foldersCount,
      this.id,
      this.title,
      this.access,
      this.shared,
      this.rootFolderType,
      this.updatedBy,
      this.created,
      this.createdBy,
      this.updated});

  Folder.fromJson(Map<String, dynamic> json) {
    parentId = json['parentId'] as int?;
    filesCount = json['filesCount'] as int?;
    foldersCount = json['foldersCount'] as int?;
    id = json['id'] as int?;
    title = json['title'] as String?;
    access = json['access'] as int?;
    shared = json['shared'] as bool?;
    rootFolderType = json['rootFolderType'] as int?;
    updatedBy = json['updatedBy'] != null
        ? PortalUser.fromJson(json['updatedBy'] as Map<String, dynamic>)
        : null;
    created = DateTime.parse(json['created'] as String);
    createdBy = json['createdBy'] != null
        ? PortalUser.fromJson(json['createdBy'] as Map<String, dynamic>)
        : null;
    updated = DateTime.parse(json['updated'] as String);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['parentId'] = parentId;
    data['filesCount'] = filesCount;
    data['foldersCount'] = foldersCount;
    data['id'] = id;
    data['title'] = title;
    data['access'] = access;
    data['shared'] = shared;
    data['rootFolderType'] = rootFolderType;
    if (updatedBy != null) {
      data['updatedBy'] = updatedBy!.toJson();
    }
    data['created'] = created?.toIso8601String();
    if (createdBy != null) {
      data['createdBy'] = createdBy!.toJson();
    }
    data['updated'] = updated?.toIso8601String();
    return data;
  }
}
