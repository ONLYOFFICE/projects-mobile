import 'package:intl/intl.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project_owner.dart';

class PortalTask {
  bool canEdit;
  bool canCreateSubtask;
  bool canCreateTimeSpend;
  bool canDelete;
  bool canReadFiles;
  String startDate;
  int id;
  String title;
  String description;
  String deadline;
  int priority;
  int milestoneId;
  ProjectOwner projectOwner;
  int status;
  PortalUser responsible;
  PortalUser updatedBy;
  String created;
  PortalUser createdBy;
  String updated;
  List<PortalUser> responsibles;

  PortalTask(
      {this.canEdit,
      this.canCreateSubtask,
      this.canCreateTimeSpend,
      this.canDelete,
      this.canReadFiles,
      this.startDate,
      this.id,
      this.title,
      this.description,
      this.deadline,
      this.priority,
      this.milestoneId,
      this.projectOwner,
      this.status,
      this.responsible,
      this.updatedBy,
      this.created,
      this.createdBy,
      this.updated,
      this.responsibles});

  PortalTask.fromJson(Map<String, dynamic> json) {
    canEdit = json['canEdit'];
    canCreateSubtask = json['canCreateSubtask'];
    canCreateTimeSpend = json['canCreateTimeSpend'];
    canDelete = json['canDelete'];
    canReadFiles = json['canReadFiles'];
    startDate = json['startDate'];
    id = json['id'];
    title = json['title'];
    description = json['description'];
    deadline = json['deadline'];
    priority = json['priority'];
    milestoneId = json['milestoneId'];
    projectOwner = json['projectOwner'] != null
        ? ProjectOwner.fromJson(json['projectOwner'])
        : null;
    status = json['status'];
    responsible = json['responsible'] != null
        ? PortalUser.fromJson(json['responsible'])
        : null;
    updatedBy = json['updatedBy'] != null
        ? PortalUser.fromJson(json['updatedBy'])
        : null;
    created = json['created'];
    createdBy = json['createdBy'] != null
        ? PortalUser.fromJson(json['createdBy'])
        : null;
    updated = json['updated'];

    responsibles = json['responsibles'] != null
        ? (json['responsibles'] as List)
            .map((i) => PortalUser.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['canEdit'] = canEdit;
    data['canCreateSubtask'] = canCreateSubtask;
    data['canCreateTimeSpend'] = canCreateTimeSpend;
    data['canDelete'] = canDelete;
    data['canReadFiles'] = canReadFiles;
    data['startDate'] = startDate;
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['deadline'] = deadline;
    data['priority'] = priority;
    data['milestoneId'] = milestoneId;
    if (projectOwner != null) {
      data['projectOwner'] = projectOwner.toJson();
    }
    data['status'] = status;
    if (responsible != null) {
      data['responsible'] = responsible.toJson();
    }
    if (updatedBy != null) {
      data['updatedBy'] = updatedBy.toJson();
    }
    data['created'] = created;
    if (createdBy != null) {
      data['createdBy'] = createdBy.toJson();
    }
    data['updated'] = updated;
    return data;
  }

  String creationDate() {
    final now = DateTime.parse(created);
    final formatter = DateFormat('d MMM.yyy');
    return formatter.format(now);
  }
}
