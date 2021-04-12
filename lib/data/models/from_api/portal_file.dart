import 'package:projects/data/models/from_api/portal_user.dart';

class PortalFile {
  bool shared;
  DateTime created;
  DateTime updated;
  dynamic comment;
  int access;
  int fileStatus;
  int fileType;
  int folderId;
  int id;
  int pureContentLength;
  int rootFolderType;
  int version;
  int versionGroup;
  PortalUser createdBy;
  PortalUser updatedBy;
  String contentLength;
  String fileExst;
  String title;
  String thumbnailUrl;
  String viewUrl;

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
        access: json['access'],
        comment: json['comment'],
        contentLength: json['contentLength'],
        created: DateTime.parse(json['created']),
        createdBy: json['createdBy'] != null
            ? PortalUser.fromJson(json['createdBy'])
            : null,
        fileExst: json['fileExst'],
        fileStatus: json['fileStatus'],
        fileType: json['fileType'],
        id: json['id'],
        pureContentLength: json['pureContentLength'],
        rootFolderType: json['rootFolderType'],
        shared: json['shared'],
        title: json['title'],
        thumbnailUrl: json['thumbnailUrl'],
        updated: DateTime.parse(json['updated']),
        updatedBy: json['updatedBy'] != null
            ? PortalUser.fromJson(json['updatedBy'])
            : null,
        version: json['version'],
        versionGroup: json['versionGroup'],
        viewUrl: json['viewUrl'],
        folderId: json['folderId'],
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
