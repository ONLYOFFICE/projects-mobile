class NewTaskDTO {
  NewTaskDTO({
    this.description,
    this.deadline,
    this.priority,
    this.projectId,
    this.title,
    this.milestoneid,
    this.responsibles,
    this.notify,
    this.startDate,
  });

  final String description;
  final String priority;
  final String title;
  final int milestoneid;
  final int projectId;
  final List<String> responsibles;
  // DateTime here but Iso8601String when sends to api
  final DateTime deadline;
  // DateTime here but Iso8601String when sends to api
  final DateTime startDate;
  final bool notify;

  factory NewTaskDTO.fromJson(Map<String, dynamic> json) => NewTaskDTO(
        description: json['description'],
        deadline:
            json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
        priority: json['priority'],
        title: json['title'],
        milestoneid: json['milestoneid'],
        projectId: json['projectid'],
        responsibles: List<String>.from(json['responsibles'].map((x) => x)),
        notify: json['notify'],
        startDate: json['startDate'] != null
            ? DateTime.parse(json['startDate'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'description': description,
        'deadline': deadline != null ? deadline.toIso8601String() : null,
        'priority': priority,
        'title': title,
        'milestoneid': milestoneid,
        'projectid': projectId,
        'responsibles': List<dynamic>.from(responsibles.map((x) => x)),
        'notify': notify,
        'startDate': startDate != null ? startDate.toIso8601String() : null
      };
}
