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
  // int projectID;
  bool canReadFiles;
  bool canReadMilestones;
  bool canReadMessages;
  bool canReadTasks;
  bool canReadContacts;
  // bool isVisitor;
  // bool isFullAdmin;
  // Null userInfo;
  // bool isAdmin;
  // bool isManager;
  // bool isRemovedFromTeam;
  // int projectTeamSecurity;

  Participant({
    this.iD,
    // this.projectID,
    this.canReadFiles,
    this.canReadMilestones,
    this.canReadMessages,
    this.canReadTasks,
    this.canReadContacts,
    // this.isVisitor,
    // this.isFullAdmin,
    // this.userInfo,
    // this.isAdmin,
    // this.isManager,
    // this.isRemovedFromTeam,
    // this.projectTeamSecurity
  });

  Participant.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    // projectID = json['ProjectID'];
    canReadFiles = json['CanReadFiles'];
    canReadMilestones = json['CanReadMilestones'];
    canReadMessages = json['CanReadMessages'];
    canReadTasks = json['CanReadTasks'];
    canReadContacts = json['CanReadContacts'];
    // isVisitor = json['IsVisitor'];
    // isFullAdmin = json['IsFullAdmin'];
    // userInfo = json['UserInfo'];
    // isAdmin = json['IsAdmin'];
    // isManager = json['IsManager'];
    // isRemovedFromTeam = json['IsRemovedFromTeam'];
    // projectTeamSecurity = json['ProjectTeamSecurity'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ID'] = iD;
    // data['ProjectID'] = projectID;
    data['CanReadFiles'] = canReadFiles;
    data['CanReadMilestones'] = canReadMilestones;
    data['CanReadMessages'] = canReadMessages;
    data['CanReadTasks'] = canReadTasks;
    data['CanReadContacts'] = canReadContacts;
    // data['IsVisitor'] = isVisitor;
    // data['IsFullAdmin'] = isFullAdmin;
    // data['UserInfo'] = userInfo;
    // data['IsAdmin'] = isAdmin;
    // data['IsManager'] = isManager;
    // data['IsRemovedFromTeam'] = isRemovedFromTeam;
    // data['ProjectTeamSecurity'] = projectTeamSecurity;
    return data;
  }
}
