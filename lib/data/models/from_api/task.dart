import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/project_owner.dart';

class PortalTask {
  int customTaskStatus;
  int id;
  int milestoneId;
  int priority;
  int status;
  bool canCreateSubtask;
  bool canCreateTimeSpend;
  bool canDelete;
  bool canEdit;
  bool canReadFiles;
  String created;
  String deadline;
  String description;
  String startDate;
  String title;
  String updated;
  List<PortalUser> responsibles;
  List<Subtask> subtasks;
  PortalUser createdBy;
  PortalUser responsible;
  PortalUser updatedBy;
  ProjectOwner projectOwner;

  PortalTask(
      {this.canCreateSubtask,
      this.canCreateTimeSpend,
      this.canDelete,
      this.canEdit,
      this.canReadFiles,
      this.created,
      this.createdBy,
      this.customTaskStatus,
      this.deadline,
      this.description,
      this.id,
      this.milestoneId,
      this.priority,
      this.projectOwner,
      this.responsible,
      this.responsibles,
      this.startDate,
      this.status,
      this.title,
      this.updated,
      this.updatedBy});

  PortalTask.fromJson(Map<String, dynamic> json) {
    canEdit = json['canEdit'];
    canCreateSubtask = json['canCreateSubtask'];
    canCreateTimeSpend = json['canCreateTimeSpend'];
    canDelete = json['canDelete'];
    canReadFiles = json['canReadFiles'];
    customTaskStatus = json['customTaskStatus'];
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

    subtasks =
        List<Subtask>.from(json['subtasks'].map((x) => Subtask.fromJson(x)));

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
    data['customTaskStatus'] = customTaskStatus;
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

    data['subtasks'] = List<dynamic>.from(subtasks.map((x) => x.toJson()));

    data['updated'] = updated;
    return data;
  }
}

class Subtask {
  final bool canEdit;
  final int taskId;
  final int id;
  final String title;
  final dynamic description;
  final int status;
  final PortalUser responsible;
  final DateTime created;
  final PortalUser createdBy;
  final PortalUser updatedBy;
  final DateTime updated;

  Subtask({
    this.canEdit,
    this.taskId,
    this.id,
    this.title,
    this.description,
    this.status,
    this.responsible,
    this.created,
    this.createdBy,
    this.updatedBy,
    this.updated,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) => Subtask(
        canEdit: json['canEdit'],
        taskId: json['taskId'],
        id: json['id'],
        title: json['title'],
        description: json['description'],
        status: json['status'],
        responsible: json['responsible'] == null
            ? null
            : PortalUser.fromJson(json['responsible']),
        updatedBy: json['updatedBy'] == null
            ? null
            : PortalUser.fromJson(json['updatedBy']),
        created:
            json['created'] == null ? null : DateTime.parse(json['created']),
        createdBy: json['createdBy'] == null
            ? null
            : PortalUser.fromJson(json['createdBy']),
        updated:
            json['updated'] == null ? null : DateTime.parse(json['updated']),
      );

  Map<String, dynamic> toJson() => {
        'canEdit': canEdit,
        'taskId': taskId,
        'id': id,
        'title': title,
        'description': description,
        'status': status,
        'responsible': responsible == null ? null : responsible.toJson(),
        'updatedBy': updatedBy == null ? null : updatedBy.toJson(),
        'created': created == null ? null : created.toIso8601String(),
        'createdBy': createdBy == null ? null : createdBy.toJson(),
        'updated': updated == null ? null : updated.toIso8601String(),
      };
}
