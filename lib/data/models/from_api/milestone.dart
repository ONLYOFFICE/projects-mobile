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

  bool canDelete;
  bool canEdit;
  bool isKey;
  bool isNotify;
  DateTime created;
  DateTime deadline;
  DateTime updated;
  int activeTaskCount;
  int closedTaskCount;
  int id;
  int status;
  PortalUser createdBy;
  PortalUser responsible;
  PortalUser updatedBy;
  ProjectOwner projectOwner;
  String description;
  String title;

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
        canEdit: json['canEdit'],
        canDelete: json['canDelete'],
        id: json['id'],
        title: json['title'],
        description: json['description'],
        deadline:
            json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
        isKey: json['isKey'],
        isNotify: json['isNotify'],
        activeTaskCount: json['activeTaskCount'],
        closedTaskCount: json['closedTaskCount'],
        status: json['status'],
        created:
            json['created'] != null ? DateTime.parse(json['created']) : null,
        createdBy: json['createdBy'] != null
            ? PortalUser.fromJson(json['createdBy'])
            : null,
        projectOwner: json['projectOwner'] != null
            ? ProjectOwner.fromJson(json['projectOwner'])
            : null,
        responsible: json['responsible'] != null
            ? PortalUser.fromJson(json['responsible'])
            : null,
        updatedBy: json['updatedBy'] != null
            ? PortalUser.fromJson(json['updatedBy'])
            : null,
        updated:
            json['updated'] != null ? DateTime.parse(json['updated']) : null,
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
        if (projectOwner != null) 'projectOwner': projectOwner.toJson(),
        if (responsible != null) 'responsible': responsible.toJson(),
        if (updatedBy != null) 'updatedBy': updatedBy.toJson(),
        if (createdBy != null) 'createdBy': createdBy.toJson()
      };
}
