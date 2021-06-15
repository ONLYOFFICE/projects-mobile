import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project_owner.dart';

class Discussion {
  Discussion({
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

  final DateTime created;
  final DateTime updated;
  final PortalUser createdBy;
  final PortalUser updatedBy;
  final ProjectOwner projectOwner;
  final String text;
  final String title;
  final bool canCreateComment;
  final bool canEdit;
  final dynamic description;
  final int commentsCount;
  final int id;
  final int status;

  factory Discussion.fromJson(Map<String, dynamic> json) => Discussion(
        canCreateComment: json['canCreateComment'],
        canEdit: json['canEdit'],
        id: json['id'],
        title: json['title'],
        description: json['description'],
        projectOwner: json['projectOwner'] != null
            ? ProjectOwner.fromJson(json['projectOwner'])
            : null,
        commentsCount: json['commentsCount'],
        text: json['text'],
        status: json['status'],
        updatedBy: json['updatedBy'] != null
            ? PortalUser.fromJson(json['updatedBy'])
            : null,
        created:
            json['created'] != null ? DateTime.parse(json['created']) : null,
        createdBy: json['createdBy'] != null
            ? PortalUser.fromJson(json['createdBy'])
            : null,
        updated:
            json['updated'] != null ? DateTime.parse(json['updated']) : null,
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
}
