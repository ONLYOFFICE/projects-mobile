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

import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';

class MoveFolderResponse {
  String id;
  int operation;
  int progress;
  String error;
  String processed;
  bool finished;
  String url;
  List<PortalFile> files;
  List<Folder> folders;

  MoveFolderResponse(
      {this.id,
      this.operation,
      this.progress,
      this.error,
      this.processed,
      this.finished,
      this.url,
      this.files,
      this.folders});

  MoveFolderResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operation = json['operation'];
    progress = json['progress'];
    error = json['error'];
    processed = json['processed'];
    finished = json['finished'];
    url = json['url'];
    if (json['files'] != null) {
      files = <PortalFile>[];
      json['files'].forEach((v) {
        files.add(PortalFile.fromJson(v));
      });
    }
    if (json['folders'] != null) {
      folders = <Folder>[];
      json['folders'].forEach((v) {
        folders.add(Folder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['operation'] = operation;
    data['progress'] = progress;
    data['error'] = error;
    data['processed'] = processed;
    data['finished'] = finished;
    data['url'] = url;
    if (files != null) {
      data['files'] = files.map((v) => v.toJson()).toList();
    }
    if (folders != null) {
      data['folders'] = folders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
