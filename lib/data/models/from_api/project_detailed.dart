import 'package:projects/data/models/from_api/portal_user.dart';

class ProjectDetailed {
  bool canEdit;
  bool canDelete;
  Map<String, dynamic> security;
  int projectFolder;
  int id;
  String title;
  String description;
  int status;
  PortalUser responsible;
  bool isPrivate;
  int taskCount;
  int taskCountTotal;
  int milestoneCount;
  int discussionCount;
  int participantCount;
  String timeTrackingTotal;
  int documentsCount;
  bool isFollow;
  PortalUser updatedBy;
  String created;
  PortalUser createdBy;
  String updated;
  List<String> tags;

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
      this.updated,
      this.tags});

  ProjectDetailed.fromJson(Map<String, dynamic> json) {
    canEdit = json['canEdit'];
    canDelete = json['canDelete'];
    security = json['security'];

    projectFolder = json['projectFolder'] is int
        ? json['projectFolder']
        : int.parse(json['projectFolder']);
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    responsible = json['responsible'] != null
        ? PortalUser.fromJson(json['responsible'])
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
    updatedBy = json['updatedBy'] != null
        ? PortalUser.fromJson(json['updatedBy'])
        : null;
    created = json['created'];
    createdBy = json['createdBy'] != null
        ? PortalUser.fromJson(json['createdBy'])
        : null;
    updated = json['updated'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : null;
  }
}
