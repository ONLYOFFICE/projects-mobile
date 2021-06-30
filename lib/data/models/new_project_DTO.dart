class NewProjectDTO {
  String title;
  String description;
  String responsibleId;
  String tags;
  bool private;
  List<Participant> participants;
  bool notify;
  // List<Null> tasks;
  // List<Null> milestones;
  bool notifyResponsibles;

  NewProjectDTO(
      {this.title,
      this.description,
      this.responsibleId,
      this.tags,
      this.private,
      this.participants,
      this.notify,
      // tasks,
      // milestones,
      this.notifyResponsibles});

  NewProjectDTO.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    responsibleId = json['responsibleId'];
    tags = json['tags'];
    private = json['private'];
    if (json['participants'] != null) {
      participants = <Participant>[];
      json['participants'].forEach((v) {
        participants.add(Participant.fromJson(v));
      });
    }
    notify = json['notify'];
    notifyResponsibles = json['notifyResponsibles'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['responsibleId'] = responsibleId;
    data['tags'] = tags;
    data['private'] = private;
    if (participants != null) {
      data['participants'] = participants.map((v) => v.toJson()).toList();
    }
    data['notify'] = notify;
    // if (tasks != null) {
    //   data['tasks'] = tasks.map((v) => v.toJson()).toList();
    // }
    // if (milestones != null) {
    //   data['milestones'] = milestones.map((v) => v.toJson()).toList();
    // }
    data['notifyResponsibles'] = notifyResponsibles;
    return data;
  }
}

class Participant {
  String iD;
  bool canReadFiles;
  bool canReadMilestones;
  bool canReadMessages;
  bool canReadTasks;
  bool canReadContacts;

  Participant({
    this.iD,
    // this.projectID,
    this.canReadFiles,
    this.canReadMilestones,
    this.canReadMessages,
    this.canReadTasks,
    this.canReadContacts,
  });

  Participant.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    canReadFiles = json['CanReadFiles'];
    canReadMilestones = json['CanReadMilestones'];
    canReadMessages = json['CanReadMessages'];
    canReadTasks = json['CanReadTasks'];
    canReadContacts = json['CanReadContacts'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ID'] = iD;
    data['CanReadFiles'] = canReadFiles;
    data['CanReadMilestones'] = canReadMilestones;
    data['CanReadMessages'] = canReadMessages;
    data['CanReadTasks'] = canReadTasks;
    data['CanReadContacts'] = canReadContacts;
    return data;
  }
}

class EditProjectDTO {
  String title;
  String description;
  String responsibleId;
  String tags;
  List<Participant> participants;
  bool private;
  int status;
  // bool notify;

  EditProjectDTO({
    this.title,
    this.description,
    this.responsibleId,
    this.tags,
    this.participants,
    this.private,
    this.status,
    // this.notify,
  });

  EditProjectDTO.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    responsibleId = json['responsibleId'];
    tags = json['tags'];
    if (json['participants'] != null) {
      participants = <Participant>[];
      json['participants'].forEach((v) {
        participants.add(Participant.fromJson(v));
      });
    }
    private = json['private'];
    status = json['status'];
    // notify = json['notify'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['responsibleId'] = responsibleId;
    data['tags'] = tags;
    if (participants != null) {
      data['participants'] = participants.map((v) => v.iD).toList();
    }
    data['private'] = private;
    data['status'] = status;
    // data['notify'] = notify;
    return data;
  }
}
