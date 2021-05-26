import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/models/from_api/portal_user.dart';

class FoldersResponse {
  List<PortalFile> files;
  List<Folder> folders;
  Folder current;
  List<int> pathParts;
  int startIndex;
  int count;
  int total;

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
    current = json['current'] != null ? Folder.fromJson(json['current']) : null;
    pathParts = json['pathParts'].cast<int>();
    startIndex = json['startIndex'];
    count = json['count'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (files != null) {
      data['files'] = files.map((v) => v.toJson()).toList();
    }
    if (folders != null) {
      data['folders'] = folders.map((v) => v.toJson()).toList();
    }
    if (current != null) {
      data['current'] = current.toJson();
    }
    data['pathParts'] = pathParts;
    data['startIndex'] = startIndex;
    data['count'] = count;
    data['total'] = total;
    return data;
  }
}

class Folder {
  int parentId;
  int filesCount;
  int foldersCount;
  int id;
  String title;
  int access;
  bool shared;
  int rootFolderType;
  PortalUser updatedBy;
  DateTime created;
  PortalUser createdBy;
  DateTime updated;

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
    parentId = json['parentId'];
    filesCount = json['filesCount'];
    foldersCount = json['foldersCount'];
    id = json['id'];
    title = json['title'];
    access = json['access'];
    shared = json['shared'];
    rootFolderType = json['rootFolderType'];
    updatedBy = json['updatedBy'] != null
        ? PortalUser.fromJson(json['updatedBy'])
        : null;
    created = DateTime.parse(json['created']);
    createdBy = json['createdBy'] != null
        ? PortalUser.fromJson(json['createdBy'])
        : null;
    updated = DateTime.parse(json['updated']);
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
      data['updatedBy'] = updatedBy.toJson();
    }
    data['created'] = created?.toIso8601String();
    if (createdBy != null) {
      data['createdBy'] = createdBy.toJson();
    }
    data['updated'] = updated?.toIso8601String();
    return data;
  }
}
