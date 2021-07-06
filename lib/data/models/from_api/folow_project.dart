import 'package:projects/data/models/from_api/portal_user.dart';

class FollowProject {
  int id;
  String title;
  String description;
  int status;
  PortalUser responsible;
  bool canEdit;
  bool isPrivate;

  FollowProject(
      {this.id,
      this.title,
      this.description,
      this.status,
      this.responsible,
      this.canEdit,
      this.isPrivate});

  FollowProject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    responsible = json['responsible'] != null
        ? PortalUser.fromJson(json['responsible'])
        : null;
    canEdit = json['canEdit'];
    isPrivate = json['isPrivate'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['status'] = status;
    if (responsible != null) {
      data['responsible'] = responsible.toJson();
    }
    data['canEdit'] = canEdit;
    data['isPrivate'] = isPrivate;
    return data;
  }
}
