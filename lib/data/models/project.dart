class Project {
  Project({
    this.id,
    this.description,
    this.title,
    this.status,
    this.canEdit,
    this.isPrivate,
    this.responsible,
  });
  int id;
  String description;
  String title;
  int status;
  bool canEdit;
  bool isPrivate;

  Responsible responsible;

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    title = json['title'];
    status = json['status'];
    canEdit = json['canEdit'];
    isPrivate = json['isPrivate'];
    responsible = Responsible.fromJson(json['responsible']);
  }
}

class Responsible {
  Responsible({
    this.id,
    this.displayName,
    this.title,
    this.avatarSmall,
    this.profileUrl,
  });
  String id;
  String displayName;
  String title;
  String avatarSmall;
  String profileUrl;

  Responsible.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    title = json['title'];
    avatarSmall = json['avatarSmall'];
    profileUrl = json['profileUrl'];
  }
}
