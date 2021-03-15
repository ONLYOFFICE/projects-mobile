import 'package:intl/intl.dart';
import 'package:only_office_mobile/data/models/portal_user.dart';

class ProjectDetailed {
  bool canEdit;
  bool canDelete;
  Map<String, dynamic> security;
  String projectFolder;
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
        ? new PortalUser.fromJson(json['responsible'])
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
        ? new PortalUser.fromJson(json['updatedBy'])
        : null;
    created = json['created'];
    createdBy = json['createdBy'] != null
        ? new PortalUser.fromJson(json['createdBy'])
        : null;
    updated = json['updated'];
  }

  String createdDate() {
    final DateTime now = DateTime.parse(created);
    final DateFormat formatter = DateFormat('d MMM.yyy');
    return formatter.format(now);
  }
}
