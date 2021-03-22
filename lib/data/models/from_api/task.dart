import 'package:intl/intl.dart';
import 'package:only_office_mobile/data/models/from_api/portal_user.dart';
import 'package:only_office_mobile/data/models/from_api/project_owner.dart';

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
        ? new ProjectOwner.fromJson(json['projectOwner'])
        : null;
    status = json['status'];
    responsible = json['responsible'] != null
        ? new PortalUser.fromJson(json['responsible'])
        : null;
    updatedBy = json['updatedBy'] != null
        ? new PortalUser.fromJson(json['updatedBy'])
        : null;
    created = json['created'];
    createdBy = json['createdBy'] != null
        ? new PortalUser.fromJson(json['createdBy'])
        : null;
    updated = json['updated'];

    responsibles = json['responsibles'] != null
        ? (json['responsibles'] as List)
            .map((i) => PortalUser.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['canEdit'] = this.canEdit;
    data['canCreateSubtask'] = this.canCreateSubtask;
    data['canCreateTimeSpend'] = this.canCreateTimeSpend;
    data['canDelete'] = this.canDelete;
    data['canReadFiles'] = this.canReadFiles;
    data['startDate'] = this.startDate;
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['deadline'] = this.deadline;
    data['priority'] = this.priority;
    data['milestoneId'] = this.milestoneId;
    if (this.projectOwner != null) {
      data['projectOwner'] = this.projectOwner.toJson();
    }
    data['status'] = this.status;
    if (this.responsible != null) {
      data['responsible'] = this.responsible.toJson();
    }
    if (this.updatedBy != null) {
      data['updatedBy'] = this.updatedBy.toJson();
    }
    data['created'] = this.created;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy.toJson();
    }
    data['updated'] = this.updated;
    return data;
  }

  String creationDate() {
    final DateTime now = DateTime.parse(created);
    final DateFormat formatter = DateFormat('d MMM.yyy');
    return formatter.format(now);
  }
}
