import 'package:only_office_mobile/data/models/from_api/portal_user.dart';

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

  PortalUser responsible;

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    title = json['title'];
    status = json['status'];
    canEdit = json['canEdit'];
    isPrivate = json['isPrivate'];
    responsible = PortalUser.fromJson(json['responsible']);
  }
}
