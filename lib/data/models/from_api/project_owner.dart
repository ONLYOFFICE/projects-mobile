class ProjectOwner {
  int id;
  String title;
  int status;
  bool isPrivate;

  ProjectOwner({this.id, this.title, this.status, this.isPrivate});

  ProjectOwner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    isPrivate = json['isPrivate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['isPrivate'] = isPrivate;
    return data;
  }
}
