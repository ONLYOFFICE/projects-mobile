class NewTaskDTO {
  NewTaskDTO({
    this.copyFiles,
    this.copySubtasks,
    this.deadline,
    this.description,
    this.id,
    this.milestoneid,
    this.notify,
    this.priority,
    this.projectId,
    this.removeOld,
    this.responsibles,
    this.startDate,
    this.title,
  });

  final String description;
  final String priority;
  final String title;
  final int id;
  final int milestoneid;
  final int projectId;
  final List<String> responsibles;
  // DateTime here but Iso8601String when sends to api
  final DateTime deadline;
  // DateTime here but Iso8601String when sends to api
  final DateTime startDate;
  // currently this is only used when copying
  final bool copyFiles;
  // currently this is only used when copying
  final bool copySubtasks;
  final bool notify;
  // currently this is only used when copying
  final bool removeOld;

  factory NewTaskDTO.fromJson(Map<String, dynamic> json) => NewTaskDTO(
        description: json['description'],
        deadline:
            json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
        id: json['id'],
        priority: json['priority'],
        title: json['title'],
        milestoneid: json['milestoneid'],
        projectId: json['projectid'],
        responsibles: List<String>.from(json['responsibles'].map((x) => x)),
        notify: json['notify'],
        startDate: json['startDate'] != null
            ? DateTime.parse(json['startDate'])
            : null,
        copyFiles: json['copyFiles'],
        copySubtasks: json['copySubtasks'],
        removeOld: json['removeOld'],
      );

  Map<String, dynamic> toJson() => {
        'description': description,
        'deadline': deadline != null ? deadline.toIso8601String() : null,
        'id': id,
        'priority': priority,
        'title': title,
        'milestoneid': milestoneid,
        'projectid': projectId,
        'responsibles': responsibles != null
            ? List<dynamic>.from(responsibles.map((x) => x))
            : null,
        'notify': notify,
        'startDate': startDate != null ? startDate.toIso8601String() : null,
        'copyFiles': copyFiles,
        'copySubtasks': copySubtasks,
        'removeOld': removeOld,
      };
}
