class NewProjectDTO {
  String title;
  String description;
  String responsibleId;
  String tags;
  bool private;
  List<String> participants;
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
      // this.tasks,
      // this.milestones,
      this.notifyResponsibles});

  NewProjectDTO.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    responsibleId = json['responsibleId'];
    tags = json['tags'];
    private = json['private'];
    participants = json['participants'].cast<String>();
    notify = json['notify'];
    // if (json['tasks'] != null) {
    //   tasks = [];
    //   json['tasks'].forEach((v) {
    //     tasks.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['milestones'] != null) {
    //   milestones = new List<Null>();
    //   json['milestones'].forEach((v) {
    //     milestones.add(new Null.fromJson(v));
    //   });
    // }
    notifyResponsibles = json['notifyResponsibles'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['responsibleId'] = responsibleId;
    data['tags'] = tags;
    data['private'] = private;
    data['participants'] = participants;
    data['notify'] = notify;
    // if (this.tasks != null) {
    //   data['tasks'] = this.tasks.map((v) => v.toJson()).toList();
    // }
    // if (this.milestones != null) {
    //   data['milestones'] = this.milestones.map((v) => v.toJson()).toList();
    // }
    data['notifyResponsibles'] = notifyResponsibles;
    return data;
  }
}
