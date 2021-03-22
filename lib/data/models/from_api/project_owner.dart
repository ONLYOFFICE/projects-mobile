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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['isPrivate'] = this.isPrivate;
    return data;
  }
}
